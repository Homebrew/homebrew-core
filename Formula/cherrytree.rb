class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree"
  url "https://www.giuspen.com/software/cherrytree_0.99.32.tar.xz"
  sha256 "cafc3233e2c22b6e689d4d58cfe87e0b5fcf342b549d23122bfcac4025b6d3c6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "d52717581e93cf1d236f4857cccb8f3880efd040c59d14be31ad1e4e4e6b95c0"
    sha256 big_sur:       "3850d270cd3e051da438312542dca7786c91e9ac0847020acdb61288fda5724c"
    sha256 catalina:      "d253ae29918c53a4cac6db8e4f0d55bfee0890a12463a737d8073949e31488a3"
    sha256 mojave:        "c34e216b0f9053b4882a4f01e71afea502f7ca04aabd2ed10fdb835334495b15"
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
