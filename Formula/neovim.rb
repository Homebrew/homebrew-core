class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"
  head "https://github.com/neovim/neovim.git", branch: "master"

  stable do
    url "https://github.com/neovim/neovim/archive/v0.9.0.tar.gz"
    sha256 "39d79107c54d2f3babcad2cd157c399241c04f6e75e98c18e8afaf2bb5e82937"

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
    sha256 arm64_ventura:  "ff3d6f3ff38e711f6b008e588fd98a10c30d0e4ccc89c6707ca2f037dbee9377"
    sha256 arm64_monterey: "3d7cdb361401f9a6a8fb05cd432362db2eb3e7493267dc1ab6bfa2fe2e73ecbb"
    sha256 arm64_big_sur:  "a4eb3318a46725d5ab69cc735c7ec88bbe6d41fa888f023f5f21c52985d4dbbc"
    sha256 ventura:        "48266f0c7be9338047bb36e7b27674735e68feb7334902d5631f973ea49909eb"
    sha256 monterey:       "7d39f239db202219465165d2a569911fec080e8db0f72d5fca1586231e87a6ee"
    sha256 big_sur:        "d6e83332af39562ce86df8473e586d9e541490df8217e84c5040b787c4d0f1ce"
    sha256 x86_64_linux:   "37bf617a5181b052e12224f8c3dd9ffbc2001acabfdc838ffaf9cbcf334d22b7"
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
    url "https://github.com/libmpack/libmpack-lua/releases/download/1.0.10/libmpack-lua-1.0.10.tar.gz"
    sha256 "18e202473c9a255f1d2261b019874522a4f1c6b6f989f80da93d7335933e8119"
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
        mpack/mpack-1.0.10-0.rockspec
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
