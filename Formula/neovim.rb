class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/neovim/neovim/archive/v0.9.0.tar.gz"
    sha256 "39d79107c54d2f3babcad2cd157c399241c04f6e75e98c18e8afaf2bb5e82937"

    # Remove when `mpack` resource is removed.
    depends_on "luarocks" => :build

    # Remove in 0.10.
    resource "mpack" do
      url "https://github.com/libmpack/libmpack-lua/releases/download/1.0.10/libmpack-lua-1.0.10.tar.gz"
      sha256 "18e202473c9a255f1d2261b019874522a4f1c6b6f989f80da93d7335933e8119"
    end

    # Keep resources updated according to:
    # https://github.com/neovim/neovim/blob/v#{version}/cmake.deps/CMakeLists.txt

    # TODO: Consider shipping these as separate formulae instead. See discussion at
    #       https://github.com/orgs/Homebrew/discussions/3611
    resource "tree-sitter-c" do
      url "https://github.com/tree-sitter/tree-sitter-c/archive/v0.20.2.tar.gz"
      sha256 "af66fde03feb0df4faf03750102a0d265b007e5d957057b6b293c13116a70af2"
    end

    resource "tree-sitter-lua" do
      url "https://github.com/MunifTanjim/tree-sitter-lua/archive/v0.0.14.tar.gz"
      sha256 "930d0370dc15b66389869355c8e14305b9ba7aafd36edbfdb468c8023395016d"
    end

    resource "tree-sitter-vim" do
      url "https://github.com/neovim/tree-sitter-vim/archive/v0.3.0.tar.gz"
      sha256 "403acec3efb7cdb18ff3d68640fc823502a4ffcdfbb71cec3f98aa786c21cbe2"
    end

    resource "tree-sitter-vimdoc" do
      url "https://github.com/neovim/tree-sitter-vimdoc/archive/v2.0.0.tar.gz"
      sha256 "1ff8f4afd3a9599dd4c3ce87c155660b078c1229704d1a254433e33794b8f274"
    end

    resource "tree-sitter-query" do
      url "https://github.com/nvim-treesitter/tree-sitter-query/archive/v0.1.0.tar.gz"
      sha256 "e2b806f80e8bf1c4f4e5a96248393fe6622fc1fc6189d6896d269658f67f914c"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "84d9037402952ec4a6ab76806ee93952dc53b3feb9cf04c139d4164084e50233"
    sha256 arm64_monterey: "9a7b3659523a6bce08707cb9116aa6000ee59c5c6caa9d4724b98f7a05503aa9"
    sha256 arm64_big_sur:  "c5225e16b4767ac13a3e3c02527a6d4b9ffbb11f5d8243657ddd8e3008d11bb0"
    sha256 ventura:        "309b04ac35d93eb58f0d119256b12af5b8b61f712abd0297b3fbd3c47751cf81"
    sha256 monterey:       "7e391bb77c1bc35c36ed8ca2c842f103836bcbfef18e87c07cc0003f8f2065dc"
    sha256 big_sur:        "15fc913e95ae512f1213809fb5733fcb26c7d67a635da6666f5e42217a6c054d"
    sha256 x86_64_linux:   "0a1386b4f6aa06a5f3ca9a5906827e17b170b6892e6e1bc3c6af3d50d78593d9"
  end

  # TODO: Replace with single-line `head` when `lpeg`
  #       is no longer a head-only dependency in 0.10.0.
  head do
    url "https://github.com/neovim/neovim.git", branch: "master"
    depends_on "lpeg"
  end

  depends_on "cmake" => :build
  depends_on "lpeg" => :build # needed at runtime in 0.10.0
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libtermkey"
  depends_on "libuv"
  depends_on "libvterm"
  depends_on "luajit"
  depends_on "luv"
  depends_on "msgpack"
  depends_on "tree-sitter"
  depends_on "unibilium"

  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "libnsl"
  end

  def install
    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src"/r.name)
    end

    if build.stable?
      cd "deps-build/build/src" do
        # TODO: Remove `mpack` build block in 0.10.0.
        cd "mpack" do
          luajit = Formula["luajit"]
          lua_path = "--lua-dir=#{luajit.opt_prefix}"
          deps_build = buildpath/"deps-build"

          # The path separator for `LUA_PATH` and `LUA_CPATH` is `;`.
          ENV.prepend "LUA_PATH", deps_build/"share/lua/5.1/?.lua", ";"
          ENV.prepend "LUA_CPATH", deps_build/"lib/lua/5.1/?.so", ";"
          # Don't clobber the default search path
          ENV.append "LUA_PATH", ";", ";"
          ENV.append "LUA_CPATH", ";", ";"

          rock = "mpack-1.0.10-0.rockspec"
          output = Utils.safe_popen_read("luarocks", "unpack", lua_path, rock, "--tree=#{deps_build}")
          unpack_dir = output.split("\n")[-2]

          cd unpack_dir do
            system "luarocks", "make", lua_path, "--tree=#{deps_build}"
          end
        end

        Dir["tree-sitter-*"].each do |ts_dir|
          cd ts_dir do
            cp buildpath/"cmake.deps/cmake/TreesitterParserCMakeLists.txt", "CMakeLists.txt"

            parser_name = ts_dir[/^tree-sitter-(\w+)$/, 1]
            system "cmake", "-S", ".", "-B", "build", "-DPARSERLANG=#{parser_name}", *std_cmake_args
            system "cmake", "--build", "build"

            (lib/"nvim/parser").install "build/#{parser_name}.so"
          end
        end
      end
    end

    # Point system locations inside `HOMEBREW_PREFIX`.
    inreplace "src/nvim/os/stdpaths.c" do |s|
      s.gsub! "/etc/xdg/", "#{etc}/xdg/:\\0"

      if HOMEBREW_PREFIX.to_s != HOMEBREW_DEFAULT_PREFIX
        s.gsub! "/usr/local/share/:/usr/share/", "#{HOMEBREW_PREFIX}/share/:\\0"
      end
    end

    # Replace `-dirty` suffix in `--version` output with `-Homebrew`.
    inreplace "cmake/GenerateVersion.cmake", "--dirty", "--dirty=-Homebrew"

    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBLUV_LIBRARY=#{Formula["luv"].opt_lib/shared_library("libluv")}",
                    "-DLIBUV_LIBRARY=#{Formula["libuv"].opt_lib/shared_library("libuv")}",
                    *std_cmake_args

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    return if latest_head_version.blank?

    <<~EOS
      HEAD installs of Neovim do not include any tree-sitter parsers.
      You can use the `nvim-treesitter` plugin to install them.
    EOS
  end

  test do
    refute_match "dirty", shell_output("#{bin}/nvim --version")
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath/"test.txt").read.chomp
  end
end
