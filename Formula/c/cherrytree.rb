class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree/"
  url "https://www.giuspen.com/software/cherrytree_1.1.2.tar.xz"
  sha256 "d5e7a2fddfe0577c25361695e2ea402ae34ce34d0b16e5610df2e06afa71fd2d"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?cherrytree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "877d92c7eaf3faa5d7494b709c7cc392d4d2f636dee469f59bf86aed03cb8344"
    sha256 arm64_ventura:  "f07df55b2dcafd6d808a1601452e33da6cbd037919d14f51d746dbd504d2135b"
    sha256 arm64_monterey: "2ea5abb2086fba9f8120d9e297db35464d0f96b760fbcf4a3a3ed5a19036fa99"
    sha256 sonoma:         "e2a0926e7711880c02219a0b9b30e87124961ca06fcad7a516ff132a9128b3b3"
    sha256 ventura:        "ade6a93f94a1ac4a41000ed2337b0774653b02cf5cb768f8e2d4ee65e7f27c06"
    sha256 monterey:       "40911edc827ee3fd29dd14f71712af9890ac4abf478821bf7ae8ed7d33df4474"
    sha256 x86_64_linux:   "4c970751326011ae76e51a383ec410a0fcf1929a4a854901daf83de75e317b3a"
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
