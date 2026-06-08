class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree/"
  url "https://www.giuspen.com/software/cherrytree_1.7.0.tar.xz"
  sha256 "5a015cb3af54a096a41795e42f9e41288f7189709046f81717f89d40a16f799b"
  license "GPL-3.0-or-later"
  head "https://github.com/giuspen/cherrytree.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?cherrytree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7dbc04ed755d02d8724cacd678c924441cdf4c9b2e331d00e429741057219805"
    sha256 arm64_sequoia: "e68888440aff463a046f5924ea8713c138d7743fe852c93d825ffd7f1d41e056"
    sha256 arm64_sonoma:  "a2ff02aafe9daffa8fd60201e1e0718d2b8f2332c14fdbf3a3473d7cecf060bf"
    sha256 sonoma:        "c7ac4467a86d1d0a616b52f0d3ba48bb171cd9b89cfc695b67acfed121565031"
    sha256 arm64_linux:   "a38b5c830991a85a5cdc62aebac7e44b31c63cc6d6fe4d2c702a7667f45e1492"
    sha256 x86_64_linux:  "98fcaa71eef71b86a1e478bacbfa4b8cb51546cf2992cdb959645b93640d0866"
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
