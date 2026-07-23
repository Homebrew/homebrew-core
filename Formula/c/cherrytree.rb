class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree/"
  url "https://www.giuspen.com/software/cherrytree_1.7.1.tar.xz"
  sha256 "ae2e5f14787c673c18ee4c2276e5a1b2973ed62a373b1ef8829d57d78951f0bb"
  license "GPL-3.0-or-later"
  head "https://github.com/giuspen/cherrytree.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?cherrytree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e3a9772e6fc687bbbc29642fcbb97421daf3fd3cb3bd8fd7a756fd658368fb45"
    sha256 arm64_sequoia: "e46d34a9b8e3a40bd33bca88d43271327bad2bd0420d11eb955e595d517a1a6f"
    sha256 arm64_sonoma:  "58f838e864a76d5a0d11a522bb19b6a9f2aa6cf930b34b30bd4849e424c365b1"
    sha256 sonoma:        "a89bc1198ad465451c9addd76ff983083ed37e3987246c80c02a793203192f66"
    sha256 arm64_linux:   "9509affe11b30f8a8fc14f7e3301a55bcc5c03cef8e654530123836c8a38a13e"
    sha256 x86_64_linux:  "709f810be0d1043cca430a73d4c0b197a4dd5cf5696f1bb793a48c56a49a262d"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "atkmm@2.28"
  depends_on "cairo"
  depends_on "cairomm@1.14"
  depends_on "enchant"
  depends_on "fmt"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtkmm3"
  depends_on "gtksourceview4"
  depends_on "harfbuzz"
  depends_on "librsvg" => :no_linkage # for SVG icon support
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
    depends_on "gettext"
  end

  def install
    # Link libxml2 directly: cherrytree uses its C API but CMake only links libxml++
    ENV.append "LDFLAGS", "-Wl,--no-as-needed" if OS.linux?
    ENV.append "LDFLAGS", "-lxml2"

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
