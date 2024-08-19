class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/neovim/neovim/archive/refs/tags/v0.10.1.tar.gz"
    sha256 "edce96e79903adfcb3c41e9a8238511946325ea9568fde177a70a614501af689"

    # TODO: Remove when the following commit lands in a release.
    # https://github.com/neovim/neovim/commit/fa79a8ad6deefeea81c1959d69aa4c8b2d993f99
    depends_on "libvterm"
    # TODO: Remove when the following commit lands in a release.
    # https://github.com/neovim/neovim/commit/1247684ae14e83c5b742be390de8dee00fd4e241
    depends_on "msgpack"

    # Keep resources updated according to:
    # https://github.com/neovim/neovim/blob/v#{version}/cmake.deps/CMakeLists.txt

    # TODO: Consider shipping these as separate formulae instead. See discussion at
    #       https://github.com/orgs/Homebrew/discussions/3611
    resource "tree-sitter-c" do
      url "https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v0.21.3.tar.gz"
      sha256 "75a3780df6114cd37496761c4a7c9fd900c78bee3a2707f590d78c0ca3a24368"
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
      url "https://github.com/neovim/tree-sitter-vimdoc/archive/refs/tags/v3.0.0.tar.gz"
      sha256 "a639bf92bf57bfa1cdc90ca16af27bfaf26a9779064776dd4be34c1ef1453f6c"
    end

    resource "tree-sitter-query" do
      url "https://github.com/nvim-treesitter/tree-sitter-query/archive/refs/tags/v0.4.0.tar.gz"
      sha256 "d3a423ab66dc62b2969625e280116678a8a22582b5ff087795222108db2f6a6e"
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
    sha256 arm64_sonoma:   "1c72330a7a7c7a0fd1bc94a7f6ca24ec35791624cca20400c36020a136f0cc60"
    sha256 arm64_ventura:  "7bbb635a92be0cc70bb1a03e1554f03a8a4d823730221b6f62a8c7387e55a8e5"
    sha256 arm64_monterey: "58f575f2eae27d34177889fc2f43dd92f2e5fc2f334d96a46aee4969a6294f90"
    sha256 sonoma:         "8b19ae8a53fe5cd4f655410f7a89a3ce62b3ac69facbb1cb9e6bf7c7e361a7be"
    sha256 ventura:        "8e7dafb241ed5e625262fc72e8275b1466bf189b86d1698f5e255f95e25409f8"
    sha256 monterey:       "1ccff5bcf6d6dc0285e38b3e1cfa449ba82b86796e34643681f79ed53c47b500"
    sha256 x86_64_linux:   "63f1e8c34873378647fe1a0759ae8c465419bacb76ff7276e3bd2eaac5836f77"
  end

  head do
    url "https://github.com/neovim/neovim.git", branch: "master"
    depends_on "utf8proc"
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "libuv"
  depends_on "lpeg"
  depends_on "luajit"
  depends_on "luv"
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
