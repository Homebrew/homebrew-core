class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/neovim/neovim.git", branch: "master"

  stable do
    url "https://github.com/neovim/neovim/archive/refs/tags/v0.12.1.tar.gz"
    sha256 "41898a5073631bc8fd9ac43476b811c05fb3b88ffb043d4fbb9e75e478457336"

    # Keep resources updated according to:
    # https://github.com/neovim/neovim/blob/v#{version}/cmake.deps/deps.txt

    # TODO: Consider shipping these as separate formulae instead. See discussion at
    #       https://github.com/orgs/Homebrew/discussions/3611
    # NOTE: The `install` method assumes that the parser name follows the final `-`.
    #       Please name the resources accordingly.
    resource "tree-sitter-c" do
      url "https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v0.24.1.tar.gz"
      sha256 "25dd4bb3dec770769a407e0fc803f424ce02c494a56ce95fedc525316dcf9b48"

      livecheck do
        url "https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/tree-sitter/tree-sitter-c/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end

    resource "tree-sitter-lua" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/refs/tags/v0.5.0.tar.gz"
      sha256 "cf01b93f4b61b96a6d27942cf28eeda4cbce7d503c3bef773a8930b3d778a2d9"

      livecheck do
        url "https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/tree-sitter-grammars/tree-sitter-lua/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end

    resource "tree-sitter-vim" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/refs/tags/v0.8.1.tar.gz"
      sha256 "93cafb9a0269420362454ace725a118ff1c3e08dcdfdc228aa86334b54d53c2a"

      livecheck do
        url "https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/tree-sitter-grammars/tree-sitter-vim/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end

    resource "tree-sitter-vimdoc" do
      url "https://github.com/neovim/tree-sitter-vimdoc/archive/refs/tags/v4.1.0.tar.gz"
      sha256 "020e8f117f648c8697fca967995c342e92dbd81dab137a115cc7555207fbc84f"

      livecheck do
        url "https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/neovim/tree-sitter-vimdoc/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end

    resource "tree-sitter-query" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/refs/tags/v0.8.0.tar.gz"
      sha256 "c2b23b9a54cffcc999ded4a5d3949daf338bebb7945dece229f832332e6e6a7d"

      livecheck do
        url "https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/tree-sitter-grammars/tree-sitter-query/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end

    resource "tree-sitter-markdown" do
      url "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v0.5.3.tar.gz"
      sha256 "df845b1ab7c7c163ec57d7fa17170c92b04be199bddab02523636efec5224ab6"

      livecheck do
        url "https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/tree-sitter-grammars/tree-sitter-markdown/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cdaa2f1d26932e71f4b832898b3d07f56e3932bdd4dd759aa4cda6c8fa686f66"
    sha256 arm64_sequoia: "167c282bbfa9b6553ef83ae2f3a271b0936a9013f0f90bd0fd545ff22d5370fb"
    sha256 arm64_sonoma:  "98f40270c4cf11c1e07eb4327115d22a508a5cc4247bf522f638a743a362c3b0"
    sha256 sonoma:        "2b5e37aa8f6c50608b093fa1a9fe578e9535c08610eac65cc1620c5564a9f6d2"
    sha256 arm64_linux:   "88e14a9a172834419a7b211cc8fe0f6153ebaaffcbd4ef04f472126a2290c0bb"
    sha256 x86_64_linux:  "7370f807c61ca4e2cf6f2be20992019441383d90011788b30b1f427296e1c115"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "libuv"
  depends_on "lpeg"
  depends_on "luajit"
  depends_on "luv"
  depends_on "tree-sitter"
  depends_on "unibilium"
  depends_on "utf8proc"

  on_macos do
    depends_on "gettext"
  end

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
