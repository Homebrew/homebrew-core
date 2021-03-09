class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree"
  url "https://www.giuspen.com/software/cherrytree_0.99.31.tar.xz"
  sha256 "3a3c939bdac6cc1f538b21194744f35f8f1264600bc254d7e1fc6d712dd0d560"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "6b37af5773b4722c9177ea4d4957063abba11e1d6929c36747fe6a051018f198"
    sha256 big_sur:       "d977f2cf50deeb139b2cc318a4a58cb2e6e3312e7cc5f8355b153954df43c4a3"
    sha256 catalina:      "a63c6276d213f20d66ff011bab63c194d088a27282f9aedc9de7b7fea5d7035e"
    sha256 mojave:        "f4d1b25b16f4d3197ca80ab620380af4b83bece164ddac93b96d4820094f085d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fmt"
  depends_on "gspell"
  depends_on "gtksourceviewmm3"
  depends_on "libxml++"
  depends_on "spdlog"
  depends_on "uchardet"

  uses_from_macos "curl"

  def install
    system "cmake", ".", "-DBUILD_TESTING=''", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
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
