class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree/"
  url "https://www.giuspen.com/software/cherrytree_1.7.2.tar.xz"
  sha256 "848c0478f8aa4ec2e932ed00ee6c6618f21b197bbd7fea1bafdd8456468d7d45"
  license "GPL-3.0-or-later"
  head "https://github.com/giuspen/cherrytree.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?cherrytree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "49d5769c0a164ba52e64bcb2ab9a5448decb329972b238ba950250b0f7be83b9"
    sha256 arm64_sequoia: "a0864abe2ee6110860f9b31a27022ef1cbc954dc36908a605166e5a4a49b7b17"
    sha256 arm64_sonoma:  "d0965f7bba7327416466a8301c72faf31407a9a476a48043b05bfa611668f19f"
    sha256 sonoma:        "11b38164bb6732582833d1ecac1b04e867d447e474a1eca188b0d4e7d1a5e0a5"
    sha256 arm64_linux:   "84bb7155d669b2120732f14ee4ef1015f03c5ca2a15ddaa5a4c33a1a162f960c"
    sha256 x86_64_linux:  "05486de470eb57a991494b5f689a82ba8a8f79395f9968d679574d7b3a11d9df"
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
