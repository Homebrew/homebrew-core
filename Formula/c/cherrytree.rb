class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree/"
  url "https://www.giuspen.com/software/cherrytree_1.6.2.tar.xz"
  sha256 "28c89a0b2512961e9d9393a5b8f7778f99331583c9bdbe682c4897b853727158"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/giuspen/cherrytree.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?cherrytree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0da39c5890c6683379933ed46d44757eb1a628cf27e82f30b2031319443f785f"
    sha256 arm64_sequoia: "4b2b3f3ee59c45e3b4282d7003d900bb85da386854699af157e7d5eda1735560"
    sha256 arm64_sonoma:  "f37bcfbed9a895363d678698c7142d77210f21623e2c16b9bdb5434c0b3ac206"
    sha256 sonoma:        "6e3ffc43cdc8caa056095000fae67862dd1253c76cbbe73687d96a5ec55a25c8"
    sha256 arm64_linux:   "0ee1a03bf7ce8adff030557ac6c9e28ab95df76a98690c420830b416ca249fed"
    sha256 x86_64_linux:  "be7455f0d184e38391b6779a36e8288e66d9c3723866a80b24fab8afa7f8d4a8"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atkmm@2.28"
  depends_on "cairo"
  depends_on "cairomm@1.14"
  depends_on "fmt"
  depends_on "fribidi"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtkmm3"
  depends_on "gtksourceview4"
  depends_on "libsigc++@2"
  depends_on "libxml++"
  depends_on "pango"
  depends_on "pangomm@2.46"
  depends_on "spdlog"
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency
  depends_on "uchardet"
  depends_on "vte3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "enchant"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # (cherrytree:46081): Gtk-WARNING **: 17:33:48.386: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"homebrew.ctd").write <<~XML
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
    XML

    system bin/"cherrytree", testpath/"homebrew.ctd", "--export_to_txt_dir", testpath, "--export_single_file"
    assert_path_exists testpath/"homebrew.ctd.txt"
    assert_match "rich text", (testpath/"homebrew.ctd.txt").read
    assert_match "this is a simple command line test for homebrew", (testpath/"homebrew.ctd.txt").read
    assert_match "code", (testpath/"homebrew.ctd.txt").read
    assert_match "print('hello world')", (testpath/"homebrew.ctd.txt").read
  end
end
