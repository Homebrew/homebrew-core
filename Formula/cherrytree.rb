class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree/"
  url "https://www.giuspen.com/software/cherrytree_0.99.55.tar.xz"
  sha256 "7daa4358463eb41c133d9b4b742df18f68f47fa5bf398fc2e0801fc4c8381e84"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cherrytree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c3e2cf5b7decd42ad730baf5e5aaeb2f9e11b37ab4fda6ca17e598ca3a8ee82d"
    sha256 arm64_monterey: "2fe00a9acd27abfad2e5ea408f251dc430f0e3a4ea4f58e190a93abaa2f0c1ab"
    sha256 arm64_big_sur:  "16cf9c46ee40a870c38ddd75126948272f75eef4a0928d8df9a0f8b4e844144b"
    sha256 ventura:        "ab047e618cf7c483e3fa06b6d344087c939a6cc67b0aafc34e8129e23f990711"
    sha256 monterey:       "c9f7cf3d812730ef6a818e70ce7ac20592b6893433ce379f3a34fb54a584d8c8"
    sha256 big_sur:        "0683b96e0447b2ea461f65cdb02944bb52bc22be14467ba122e7a1755ad0042d"
    sha256 x86_64_linux:   "63ba5c18d25cdf1df1a01b7757f15a29c940c5f0bf1e78f9fbf88de992aaa7f7"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fmt"
  depends_on "gspell"
  depends_on "gtksourceviewmm3"
  depends_on "libxml++"
  depends_on "spdlog"
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency
  depends_on "uchardet"
  depends_on "vte3"

  uses_from_macos "curl"

  fails_with gcc: "5" # Needs std::optional

  def install
    system "cmake", ".", "-DBUILD_TESTING=''", "-GNinja", *std_cmake_args
    system "ninja"
    system "ninja", "install"
  end

  test do
    # (cherrytree:46081): Gtk-WARNING **: 17:33:48.386: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"homebrew.ctd").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <cherrytree>
        <bookmarks list=""/>
        <node name="rich text" unique_id="1" prog_lang="custom-colors" tags="" readonly="0" custom_icon_id="0" is_bold="0" foreground="" ts_creation="1611952177" ts_lastsave="1611952932">
          <rich_text>this is a </rich_text>
          <rich_text weight="heavy">simple</rich_text>
          <rich_text> </rich_text>
          <rich_text foreground="#ffff00000000">command line</rich_text>
          <rich_text> </rich_text>
          <rich_text style="italic">test</rich_text>
          <rich_text> </rich_text>
          <rich_text family="monospace">for</rich_text>
          <rich_text> </rich_text>
          <rich_text link="webs https://brew.sh/">homebrew</rich_text>
        </node>
        <node name="code" unique_id="2" prog_lang="python3" tags="" readonly="0" custom_icon_id="0" is_bold="0" foreground="" ts_creation="1611952391" ts_lastsave="1611952667">
          <rich_text>print('hello world')</rich_text>
        </node>
      </cherrytree>
    EOS
    system "#{bin}/cherrytree", testpath/"homebrew.ctd", "--export_to_txt_dir", testpath, "--export_single_file"
    assert_predicate testpath/"homebrew.ctd.txt", :exist?
    assert_match "rich text", (testpath/"homebrew.ctd.txt").read
    assert_match "this is a simple command line test for homebrew", (testpath/"homebrew.ctd.txt").read
    assert_match "code", (testpath/"homebrew.ctd.txt").read
    assert_match "print('hello world')", (testpath/"homebrew.ctd.txt").read
  end
end
