class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree/"
  url "https://www.giuspen.com/software/cherrytree_1.1.0.tar.xz"
  sha256 "b8937e6df20c9253f6649d8b6fe7cbe5be62a457547101ae944c21d5088a1ce4"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?cherrytree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c16c6a153c912642e7efafcec86e47ee0931b7bf069795f9c3dda8a488e5a842"
    sha256 arm64_ventura:  "6a86ffbedb6507a9baf94ca31188dba1462a278319e7c97c0e210bba2cf4fc97"
    sha256 arm64_monterey: "998cb9e18584ed8fc67411fcd09529a0a27bb15c5ac3c42a0b4e4f727b195efc"
    sha256 sonoma:         "63c030b3041e7b91cefeab35426f8c04e5321b808eee0424e5c4ac11e7fb6ae1"
    sha256 ventura:        "c144c32569d48c37caf156cc99d6cb1c26f6ee2b5fe26c8a65b1c0a02b7e5ae3"
    sha256 monterey:       "80f819bfd4e52553df8ee037094ac75f17e4fbdc4379da700d527128fbb07a5b"
    sha256 x86_64_linux:   "697f38aba4be87c4480d0e934a308ea04821a7c0ad4c32f01ab320ad47ba60fd"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fmt"
  depends_on "gspell"
  depends_on "gtksourceviewmm3"
  depends_on "libxml++"
  depends_on "spdlog"
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency
  depends_on "uchardet"
  depends_on "vte3"

  uses_from_macos "python" => :build
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
