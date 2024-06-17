class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"

  head "https://github.com/neovim/neovim.git", branch: "master"

  stable do
    url "https://github.com/neovim/neovim/archive/refs/tags/v0.10.0.tar.gz"
    sha256 "372ea2584b0ea2a5a765844d95206bda9e4a57eaa1a2412a9a0726bab750f828"

    # Keep resources updated according to:
    # https://github.com/neovim/neovim/blob/v#{version}/cmake.deps/CMakeLists.txt

    # TODO: Consider shipping these as separate formulae instead. See discussion at
    #       https://github.com/orgs/Homebrew/discussions/3611
    resource "tree-sitter-c" do
      url "https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v0.21.0.tar.gz"
      sha256 "6f0f5d1b71cf8ffd8a37fb638c6022fa1245bd630150b538547d52128ce0ea7e"
    end

    resource "tree-sitter-lua" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/refs/tags/v0.1.0.tar.gz"
      sha256 "230cfcbfa74ed1f7b8149e9a1f34c2efc4c589a71fe0f5dc8560622f8020d722"
    end

    resource "tree-sitter-vim" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/refs/tags/v0.4.0.tar.gz"
      sha256 "9f856f8b4a10ab43348550fa2d3cb2846ae3d8e60f45887200549c051c66f9d5"
    end

    resource "tree-sitter-vimdoc" do
      url "https://github.com/neovim/tree-sitter-vimdoc/archive/refs/tags/v2.5.1.tar.gz"
      sha256 "063645096504b21603585507c41c6d8718ff3c11b2150c5bfc31e8f3ee9afea3"
    end

    resource "tree-sitter-query" do
      url "https://github.com/nvim-treesitter/tree-sitter-query/archive/refs/tags/v0.3.0.tar.gz"
      sha256 "f878ff37abcb83250e31a6569e997546f3dbab74dcb26683cb2d613f7568cfc0"
    end

    resource "tree-sitter-python" do
      url "https://github.com/tree-sitter/tree-sitter-python/archive/refs/tags/v0.21.0.tar.gz"
      sha256 "720304a603271fa89e4430a14d6a81a023d6d7d1171b1533e49c0ab44f1e1c13"
    end

    resource "tree-sitter-bash" do
      url "https://github.com/tree-sitter/tree-sitter-bash/archive/refs/tags/v0.21.0.tar.gz"
      sha256 "f0515efda839cfede851adb24ac154227fbc0dfb60c6c11595ecfa9087d43ceb"
    end

    resource "tree-sitter-markdown" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v0.2.3.tar.gz"
      sha256 "4909d6023643f1afc3ab219585d4035b7403f3a17849782ab803c5f73c8a31d5"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "29f56efa4ef3ad9826c6166ae3ff703143038f9b771928cb90927b88bd234e32"
    sha256 arm64_ventura:  "031b5ec26e73d2523c561bf54ffb9984012f6fd4a8610a41dbf73048713d2060"
    sha256 arm64_monterey: "5204adbe762b797feb2f8ca3005182eeef43e89bfe753ed8ad8c533cba6805f1"
    sha256 sonoma:         "2415920449c19c1b50ae5c91e0aff2b54a2c20e10c6bdacfcd77f9f09defce90"
    sha256 ventura:        "64de1ffb23f9ef9f8f51dd0d33ab19d31a290d33b1d62a422be1d4a4047820f2"
    sha256 monterey:       "fe5c86b90ee70689f94bfe05ec95f064053ad7223090f64749de8f86b3b8465c"
    sha256 x86_64_linux:   "77883d08b74050e4a609865c8e113f07b847e6eacc657b9597cf002bbc97395e"
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "libuv"
  depends_on "libvterm"
  depends_on "lpeg"
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
        Dir["tree-sitter-*"].each do |ts_dir|
          cd ts_dir do
            if ts_dir == "tree-sitter-markdown"
              cp buildpath/"cmake.deps/cmake/MarkdownParserCMakeLists.txt", "CMakeLists.txt"
            else
              cp buildpath/"cmake.deps/cmake/TreesitterParserCMakeLists.txt", "CMakeLists.txt"
            end
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
