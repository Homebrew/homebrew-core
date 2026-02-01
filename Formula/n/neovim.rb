class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"

  stable do
    # TODO: Bump to use tree-sitter 0.26+ when new Neovim release supports it
    # TODO: remove `head` block when stable supports tree-sitter 0.26+.
    url "https://github.com/neovim/neovim/archive/refs/tags/v0.11.6.tar.gz"
    sha256 "d1c8e3f484ed1e231fd5f48f53b7345b628e52263d5eef489bb8b73ca8d90fca"

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
      url "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/refs/tags/v0.4.1.tar.gz"
      sha256 "cef44b8773bde69d427b5e50ca95e417c86c0be91caa37a6782c90d6f529da70"
    end

    resource "tree-sitter-vim" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/refs/tags/v0.8.0.tar.gz"
      sha256 "aa0a45027408bc33da0f2244272dbdc0b4e71bd18f71e5b885f6f7cbae407338"
    end

    resource "tree-sitter-vimdoc" do
      url "https://github.com/neovim/tree-sitter-vimdoc/archive/refs/tags/v4.1.0.tar.gz"
      sha256 "020e8f117f648c8697fca967995c342e92dbd81dab137a115cc7555207fbc84f"
    end

    resource "tree-sitter-query" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/refs/tags/v0.8.0.tar.gz"
      sha256 "c2b23b9a54cffcc999ded4a5d3949daf338bebb7945dece229f832332e6e6a7d"
    end

    resource "tree-sitter-markdown" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v0.5.2.tar.gz"
      sha256 "122be47d4a50ac75a4f6861a17c3c88144197e0949f5d83ca917f2382b37761b"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cfd8b300b05d3dea574845a7158b08c1733502816892522bc57205475f4c97c6"
    sha256 arm64_sequoia: "a6e456b504df759202e5402f2f4ffe1213f01e06b9b3d39d95580505bf0912e1"
    sha256 arm64_sonoma:  "3ca28c90195f578a8263a2b2d7ab67f724bd80ba656423bda2e35c4cf2d92d0f"
    sha256 sonoma:        "0395c342b45728126663f10c945c2c238172763363f879c0628aa6933a19ca0b"
    sha256 arm64_linux:   "b78c6e371c8ee77189262e98078a7194365fb198dbf4c778ad69b2023732a34a"
    sha256 x86_64_linux:  "ca74f40e189c28deeff7aedc1387336fe1a31fd3b3b5a54afbedaa6ba0b8b7ff"
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
  depends_on "tree-sitter-cli"
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
