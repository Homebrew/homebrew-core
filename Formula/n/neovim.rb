class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/neovim/neovim/archive/v0.9.4.tar.gz"
    sha256 "148356027ee8d586adebb6513a94d76accc79da9597109ace5c445b09d383093"

    # Remove when `mpack` resource is removed.
    depends_on "luarocks" => :build

    # Remove in 0.10.
    resource "mpack" do
      url "https://github.com/libmpack/libmpack-lua/releases/download/1.0.11/libmpack-lua-1.0.11.tar.gz"
      sha256 "a2d9ec184867ab92ad86e251908619fa13e345b8f2c9bc99df4ac63c8039d796"
    end

    # Keep resources updated according to:
    # https://github.com/neovim/neovim/blob/v#{version}/cmake.deps/CMakeLists.txt

    # TODO: Consider shipping these as separate formulae instead. See discussion at
    #       https://github.com/orgs/Homebrew/discussions/3611
    resource "tree-sitter-c" do
      url "https://github.com/tree-sitter/tree-sitter-c/archive/v0.20.5.tar.gz"
      sha256 "694a5408246ee45d535df9df025febecdb50bee764df64a94346b9805a5f349b"
    end

    resource "tree-sitter-lua" do
      url "https://github.com/MunifTanjim/tree-sitter-lua/archive/v0.0.18.tar.gz"
      sha256 "659beef871a7fa1d9a02c23f5ebf55019aa3adce6d7f5441947781e128845256"
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
    sha256 arm64_sonoma:   "28ef7032c35b01b4d0c787cfa479a4e5cfa721920c7e16c9cfbe16ced2899f40"
    sha256 arm64_ventura:  "d86a5c7cfc96b756f1169d62f3193bb32837878ab230a52f66b752d817483465"
    sha256 arm64_monterey: "107e1eeaae2826286b8e91421b9f658da562389b1a289c321c88266b710412da"
    sha256 sonoma:         "d8349c7fc1e0605507bb7ffe8b809d459bffbc144da0d5555248f3d80358adf1"
    sha256 ventura:        "37eb3344698eba447de3497f6232fa7075488f67d8c0fec75bc2b910db05a9d0"
    sha256 monterey:       "f8b0ab4ccc82676f516e137b53b4a0de405ac2f609329106f1a286e2a1b37e50"
    sha256 x86_64_linux:   "1b4a294d242a749ca6d6eb0710fcbeb4cff8873608bd9296814edcd58983f89f"
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

          rock = "mpack-1.0.11-0.rockspec"
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
            system "cmake", "--install", "build"
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

    # Needed to find `lpeg` in non-default prefixes.
    ENV.prepend "LUA_CPATH", Formula["lpeg"].opt_lib/"lua/5.1/?.so", ";"
    # Don't clobber the default search path
    ENV.append "LUA_PATH", ";", ";"
    ENV.append "LUA_CPATH", ";", ";"

    system "cmake", "-S", ".", "-B", "build",
                    "-DLUV_LIBRARY=#{Formula["luv"].opt_lib/shared_library("libluv")}",
                    "-DLIBUV_LIBRARY=#{Formula["libuv"].opt_lib/shared_library("libuv")}",
                    "-DLPEG_LIBRARY=#{Formula["lpeg"].opt_lib/shared_library("liblpeg")}",
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
