class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree/"
  url "https://www.giuspen.com/software/cherrytree_0.99.51.tar.xz"
  sha256 "be1ef890d137a1f3728721722fd007f2bc90091a5768f5c6a9bfa473eb094281"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cherrytree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7522f94e63a4740bf8eef59572e00092d258a0cef42d5d64a6b264f4c1ce5e79"
    sha256 arm64_monterey: "fbadb047e383f75a0e2bab0733fe03c71900122b4fe15c7b4fafbbdb6c4eb270"
    sha256 arm64_big_sur:  "4bbd4ab9921b4f0589b5f1331f9a7b8b084918bd50c3b3c62a0bdbba66b55318"
    sha256 ventura:        "fce2d04ab74c54ee78d4dfb0ad55fca60857f925c0221d04a85205bcce2590e8"
    sha256 monterey:       "4dc6f9c75199d4d19258af2e676d12eb7776fea30f03457e15d5f51ca8f1c550"
    sha256 big_sur:        "241c66fa21a304aa24b3bda20b4897cd3c836cdd152612360db9887ce0b29c82"
    sha256 catalina:       "392b924031fe36ebc2043a53a507fb14d702de5aef8daf6f76b4b6676aeedd6f"
    sha256 x86_64_linux:   "a42030e5a180dc18bb50bcd7fa775741d788deb07fd9de39a482ebc645a73767"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
