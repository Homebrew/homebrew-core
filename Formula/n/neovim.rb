class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"
  revision 1

  stable do
    # TODO: Bump to use tree-sitter 0.26+ when new Neovim release supports it
    # TODO: remove `head` block when stable supports tree-sitter 0.26+.
    url "https://github.com/neovim/neovim/archive/refs/tags/v0.11.5.tar.gz"
    sha256 "c63450dfb42bb0115cd5e959f81c77989e1c8fd020d5e3f1e6d897154ce8b771"

    # TODO: Consider backporting for compatibility with 0.26
    # https://github.com/neovim/neovim/commit/f4fc769c81af6f8d9235d59aec75cfe7c104b3ce
    depends_on "tree-sitter@0.25"

    # Keep resources updated according to:
    # https://github.com/neovim/neovim/blob/v#{version}/cmake.deps/deps.txt

    # TODO: Consider shipping these as separate formulae instead. See discussion at
    #       https://github.com/orgs/Homebrew/discussions/3611
    # NOTE: The `install` method assumes that the parser name follows the final `-`.
    #       Please name the resources accordingly.
    resource "tree-sitter-c" do
      url "https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v0.24.1.tar.gz"
      sha256 "25dd4bb3dec770769a407e0fc803f424ce02c494a56ce95fedc525316dcf9b48"
    end

    resource "tree-sitter-lua" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/refs/tags/v0.4.0.tar.gz"
      sha256 "b0977aced4a63bb75f26725787e047b8f5f4a092712c840ea7070765d4049559"
    end

    resource "tree-sitter-vim" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/refs/tags/v0.7.0.tar.gz"
      sha256 "44eabc31127c4feacda19f2a05a5788272128ff561ce01093a8b7a53aadcc7b2"
    end

    resource "tree-sitter-vimdoc" do
      url "https://github.com/neovim/tree-sitter-vimdoc/archive/refs/tags/v4.0.0.tar.gz"
      sha256 "8096794c0f090b2d74b7bff94548ac1be3285b929ec74f839bd9b3ff4f4c6a0b"
    end

    resource "tree-sitter-query" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/refs/tags/v0.6.2.tar.gz"
      sha256 "90682e128d048fbf2a2a17edca947db71e326fa0b3dba4136e041e096538b4eb"
    end

    resource "tree-sitter-markdown" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v0.5.0.tar.gz"
      sha256 "14c2c948ccf0e9b606eec39b09286c59dddf28307849f71b7ce2b1d1ef06937e"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5444020bff8a2253e8760178e8be3bacf88bc755162ff5534539eb452385d8bb"
    sha256 arm64_sequoia: "6ba0dc0368baeb5d53161f666092c933f81062ce7dbafe2903d2543b802cd9cb"
    sha256 arm64_sonoma:  "8f5e68f365cf54244c24ca7552959cbeab809a7ad27d0065a1fe94e6d2c81eb4"
    sha256 sonoma:        "f133d0f05bd0fedf628543328838a824b9b15bdd7bdaaf35553a524e746430f7"
    sha256 arm64_linux:   "5e9c3847e51132f1e55d89d7f29bae30fcab992f4a2da7f4925fd3f0faadad0d"
    sha256 x86_64_linux:  "caaa35a53bbd9771f295e2480cb3a9f506d50c6fc33bcc8dbdac67cd68b0f55a"
  end

  # TODO: remove `head` block when stable supports tree-sitter 0.26+.
  head do
    url "https://github.com/neovim/neovim.git", branch: "master"
    depends_on "tree-sitter"
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "libuv"
  depends_on "lpeg"
  depends_on "luajit"
  depends_on "luv"
  depends_on "unibilium"
  depends_on "utf8proc"

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

  test do
    refute_match "dirty", shell_output("#{bin}/nvim --version")
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath/"test.txt").read.chomp
  end
end
