class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"
  head "https://github.com/neovim/neovim.git", branch: "master"

  stable do
    url "https://github.com/neovim/neovim/archive/v0.8.1.tar.gz"
    sha256 "b4484e130aa962457189f3dee34b8481943c1e395d2d684c6f8b91598494d9ec"

    # TODO: Consider shipping these as separate formulae instead. See discussion at
    #       https://github.com/orgs/Homebrew/discussions/3611
    resource "tree-sitter-c" do
      url "https://github.com/tree-sitter/tree-sitter-c/archive/v0.20.2.tar.gz"
      sha256 "af66fde03feb0df4faf03750102a0d265b007e5d957057b6b293c13116a70af2"
    end

    resource "tree-sitter-lua" do
      url "https://github.com/MunifTanjim/tree-sitter-lua/archive/v0.0.13.tar.gz"
      sha256 "564594fe0ffd2f2fb3578a15019b723e1bc94ac82cb6a0103a6b3b9ddcc6f315"
    end

    resource "tree-sitter-vim" do
      url "https://github.com/vigoux/tree-sitter-viml/archive/v0.2.0.tar.gz"
      sha256 "608dcc31a7948cb66ae7f45494620e2e9face1af75598205541f80d782ec4501"
    end

    resource "tree-sitter-help" do
      url "https://github.com/neovim/tree-sitter-vimdoc/archive/v1.1.0.tar.gz"
      sha256 "4c0ef80c6dc09acab362478950ec6be58a4ab1cbf2d95754b8fbb566e4c647a1"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "4c82c70e9edfc82ba030806a4c2184a6d836fa6d88045252fa3fbc299aaa3184"
    sha256 arm64_monterey: "ecd36021ba3421157c3a89fb03debf2fa89db38f5cc2f204183ae6230e638817"
    sha256 arm64_big_sur:  "3c2e4769053b9ed9201752b4f875a687d3d483262020d22c6acb0b429fb4e1a7"
    sha256 ventura:        "d8761d0a7f3a0ee85022bf5bfdc1b02cb9c9129548d3e9d6e54de785b1b37148"
    sha256 monterey:       "82cec22a2ed30ef8297bc27516a74b006dde3eab1076618d5489beba9a78bd53"
    sha256 big_sur:        "da00d8207ee0d8180b8ba7ac8fe2125284e4ee15c8a93e15fa7337bbbca5664c"
    sha256 catalina:       "c497ba9b034064836dd67ce3605d66288845e2b7e2dad2306566302173118c40"
    sha256 x86_64_linux:   "9ae3ad067badcd02856564a7f91b18bce61f022934e933bab78e7e3a9f447583"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
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

  # Keep resources updated according to:
  # https://github.com/neovim/neovim/blob/v#{version}/third-party/CMakeLists.txt

  resource "mpack" do
    url "https://github.com/libmpack/libmpack-lua/releases/download/1.0.8/libmpack-lua-1.0.8.tar.gz"
    sha256 "ed6b1b4bbdb56f26241397c1e168a6b1672f284989303b150f7ea8d39d1bc9e9"
  end

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.2-1.src.rock"
    sha256 "e0d0d687897f06588558168eeb1902ac41a11edd1b58f1aa61b99d0ea0abbfbc"
  end

  def install
    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src"/r.name)
    end

    # The path separator for `LUA_PATH` and `LUA_CPATH` is `;`.
    ENV.prepend "LUA_PATH", buildpath/"deps-build/share/lua/5.1/?.lua", ";"
    ENV.prepend "LUA_CPATH", buildpath/"deps-build/lib/lua/5.1/?.so", ";"
    # Don't clobber the default search path
    ENV.append "LUA_PATH", ";", ";"
    ENV.append "LUA_CPATH", ";", ";"
    lua_path = "--lua-dir=#{Formula["luajit"].opt_prefix}"

    cd "deps-build/build/src" do
      %w[
        mpack/mpack-1.0.8-0.rockspec
        lpeg/lpeg-1.0.2-1.src.rock
      ].each do |rock|
        dir, rock = rock.split("/")
        cd dir do
          output = Utils.safe_popen_read("luarocks", "unpack", lua_path, rock, "--tree=#{buildpath}/deps-build")
          unpack_dir = output.split("\n")[-2]
          cd unpack_dir do
            system "luarocks", "make", lua_path, "--tree=#{buildpath}/deps-build"
          end
        end
      end

      if build.stable?
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

      unless HOMEBREW_PREFIX.to_s == HOMEBREW_DEFAULT_PREFIX
        s.gsub! "/usr/local/share/:/usr/share/", "#{HOMEBREW_PREFIX}/share/:\\0"
      end
    end

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
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath/"test.txt").read.chomp
  end
end
