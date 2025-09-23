class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"

  head "https://github.com/neovim/neovim.git", branch: "master"

  stable do
    url "https://github.com/neovim/neovim/archive/refs/tags/v0.11.4.tar.gz"
    sha256 "83cf9543bedab8bec8c11cd50ccd9a4bf1570420a914b9a28f83ad100ca6d524"

    # Keep resources updated according to:
    # https://github.com/neovim/neovim/blob/v#{version}/cmake.deps/CMakeLists.txt

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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "185a130c175de49954d5bad5a92d83c3319e7e4deb2169128f210d9356505ac6"
    sha256 arm64_sequoia: "4e5ea3101fc902dab81e7335dee14eb21468d29be14e0a601bcb9058fe71e8ac"
    sha256 arm64_sonoma:  "a1ec1f0dd3b212a5d4383cd90b48494e69396d72854ffb5a55f9168a05e1bd56"
    sha256 arm64_ventura: "d4c18bb0fb65edc37b3518522f56219d35bbc9eb4cea6d895644ce06c3d13809"
    sha256 sonoma:        "38eb447a06347f69667a8dbb72b844c5f11e4c770eeb9cb7c6c4d9d848b424e9"
    sha256 ventura:       "5b3e2ec1c83e7493b8a3f327a983937b07e246aa5cc66f9b6113e07817c5a98e"
    sha256 arm64_linux:   "023a1ed0ad292e507c61ec56a59b3be9bbc5fbc70bbf6cecd7f4cf9f1b25f939"
    sha256 x86_64_linux:  "56ace1e455497729002c6c78155d5af571585b830a391a67bb99b686f84e6232"
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "libuv"
  depends_on "lpeg"
  depends_on "luajit"
  depends_on "luv"
  depends_on "tree-sitter"
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
