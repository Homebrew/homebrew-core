class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://github.com/neovim/neovim/archive/refs/tags/v0.10.2.tar.gz"
    sha256 "546cb2da9fffbb7e913261344bbf4cf1622721f6c5a67aa77609e976e78b8e89"

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
    # NOTE: The `install` method assumes that the parser name follows the final `-`.
    #       Please name the resources accordingly.
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
    sha256 arm64_sequoia: "b74c4a50c70b5d6b869ffec9956e971d14ea7f26e73e1ae058f355267f1226a5"
    sha256 arm64_sonoma:  "e39e1ac56d8a0c6c89d418ec494c5a3b67c08c630d7f1b82841fc070c3d50bc0"
    sha256 arm64_ventura: "6446e3d5b4aded7afd64eb05e4ddf072e04a439cb2bcd574c1f5360918fabb4b"
    sha256 sonoma:        "c59c7dfebb14003e8830fef8e225a12f205293ec72437cac67bfc48ea4888a1b"
    sha256 ventura:       "35bf10802691b493670fc8af1e15e7b1fae5bab2cbee0b07b1b8f67ac83c13dd"
    sha256 x86_64_linux:  "37003f89843037c1b019c33defba09696a6dea359875ee2b8ba85a36d11a838a"
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

  def install
    if build.head?
      cmake_deps = (buildpath/"cmake.deps/deps.txt").read.lines
      cmake_deps.each do |line|
        next unless line.match?(/TREESITTER_[^_]+_URL/)

        parser, parser_url = line.split
        parser_name = parser.delete_suffix("_URL")
        parser_sha256 = cmake_deps.find { |l| l.include?("#{parser_name}_SHA256") }.split.last
        parser_name = parser_name.downcase.tr("_", "-")

        resource parser_name do
          url parser_url
          sha256 parser_sha256
        end
      end
    end

    resources.each do |r|
      source_directory = buildpath/"deps-build/build/src"/r.name
      build_directory = buildpath/"deps-build/build"/r.name

      parser_name = r.name.split("-").last
      cmakelists = case parser_name
      when "markdown" then "MarkdownParserCMakeLists.txt"
      else "TreesitterParserCMakeLists.txt"
      end

      r.stage(source_directory)
      cp buildpath/"cmake.deps/cmake"/cmakelists, source_directory/"CMakeLists.txt"

      system "cmake", "-S", source_directory, "-B", build_directory, "-DPARSERLANG=#{parser_name}", *std_cmake_args
      system "cmake", "--build", build_directory
      system "cmake", "--install", build_directory
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

    args = [
      "-DLUV_LIBRARY=#{Formula["luv"].opt_lib/shared_library("libluv")}",
      "-DLIBUV_LIBRARY=#{Formula["libuv"].opt_lib/shared_library("libuv")}",
      "-DLPEG_LIBRARY=#{Formula["lpeg"].opt_lib/shared_library("liblpeg")}",
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      `--HEAD` installs also require:
        brew install --HEAD utf8proc
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
