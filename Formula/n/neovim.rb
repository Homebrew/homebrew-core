class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/neovim/neovim/archive/refs/tags/v0.9.5.tar.gz"
    sha256 "fe74369fc30a32ec7a086b1013acd0eacd674e7570eb1acc520a66180c9e9719"

    # Remove when `mpack` resource is removed.
    depends_on "luarocks" => :build
    # Remove in 0.10.
    # Upstream plan to replace this with `libtickit` which will subsume `libtermkey`.
    # See: https://github.com/neovim/neovim/pull/25870
    depends_on "libtermkey"

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
      url "https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v0.20.5.tar.gz"
      sha256 "694a5408246ee45d535df9df025febecdb50bee764df64a94346b9805a5f349b"
    end

    resource "tree-sitter-lua" do
      url "https://github.com/MunifTanjim/tree-sitter-lua/archive/refs/tags/v0.0.18.tar.gz"
      sha256 "659beef871a7fa1d9a02c23f5ebf55019aa3adce6d7f5441947781e128845256"
    end

    resource "tree-sitter-vim" do
      url "https://github.com/neovim/tree-sitter-vim/archive/refs/tags/v0.3.0.tar.gz"
      sha256 "403acec3efb7cdb18ff3d68640fc823502a4ffcdfbb71cec3f98aa786c21cbe2"
    end

    resource "tree-sitter-vimdoc" do
      url "https://github.com/neovim/tree-sitter-vimdoc/archive/refs/tags/v2.0.0.tar.gz"
      sha256 "1ff8f4afd3a9599dd4c3ce87c155660b078c1229704d1a254433e33794b8f274"
    end

    resource "tree-sitter-query" do
      url "https://github.com/nvim-treesitter/tree-sitter-query/archive/refs/tags/v0.1.0.tar.gz"
      sha256 "e2b806f80e8bf1c4f4e5a96248393fe6622fc1fc6189d6896d269658f67f914c"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "dceae593d688ebcab98d65cb2a8c885493ce7ceba0d87dff5e35cc9a00840382"
    sha256 arm64_ventura:  "de0f296454dd02e139ad69f6a193e597691528988389214407c4ea08677e26fb"
    sha256 arm64_monterey: "b7b6fc8764383e84657912cc17197f40fe112382dd98299713abc273131acaef"
    sha256 sonoma:         "c0d17b581f7584ea6de7e131cfbb89374d9753464fc5030d262aadf186aefb11"
    sha256 ventura:        "56162a099233d89e325b024ac3052cd7a0c7bc667071fb83f5ba4ebbeffcf8a5"
    sha256 monterey:       "cb2591d244f1ec97c38fc5f7f0d0a358d0d03a1a94432c28c1cc7c577dddb369"
    sha256 x86_64_linux:   "ab667b4b8ce2b55f8c654d85520831f05590b1df4c2ddd277149d24681643a20"
  end

  # TODO: Replace with single-line `head` when `lpeg`
  #       is no longer a head-only dependency in 0.10.0.
  head do
    url "https://github.com/neovim/neovim.git", branch: "master"
    depends_on "lpeg"
  end

  depends_on "cmake" => :build
  depends_on "lpeg" => :build # needed at runtime in 0.10.0
  depends_on "gettext"
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
          ENV["LUA_PATH"] = "#{deps_build}/share/lua/5.1/?.lua;;"
          ENV["LUA_CPATH"] = "#{deps_build}/lib/lua/5.1/?.so;;"

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
