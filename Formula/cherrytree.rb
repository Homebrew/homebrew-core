class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree"
  url "https://www.giuspen.com/software/cherrytree_0.99.30.tar.xz"
  sha256 "dff54e8c484beb35531a9aa0987759bc3d7e426979473ada40d1d022fdc50120"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "a6eb90be4cceb143782258067f97c32b4711aa05e54393e01f0432a2c6d55a42"
    sha256 big_sur:       "8aa0bfea8c3ab007a1e1c4ab3c630e1401d5cbd8495704e7d46b735617ddea6a"
    sha256 catalina:      "a57359a66ac690a5396dd94298b530d25479a417fcce50ff9ac3d5663a255246"
    sha256 mojave:        "0fe1ae41be30491106f3356761562072bd06390cccc6ac747b6924a41e57dfb1"
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
