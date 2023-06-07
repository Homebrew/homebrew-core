class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree/"
  url "https://www.giuspen.com/software/cherrytree_0.99.55.tar.xz"
  sha256 "7daa4358463eb41c133d9b4b742df18f68f47fa5bf398fc2e0801fc4c8381e84"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?cherrytree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "97e6fb6daf6d6c8ae58e6fc16a341e131874d22c739701aa7990b6a7a224b7b7"
    sha256 arm64_monterey: "2c5b3e508f82d5cb50159ed7c9c01229542cfc8468f76613df2fc1bbf10d9342"
    sha256 arm64_big_sur:  "452e380923648ad286b867be2ee8a882cd99f6ed7218f5a3bb5e8d10fcb71e80"
    sha256 ventura:        "c53e5d3eb6e4bc751e5213f43064169e2ef69acf950d1dd498eecd908391af9d"
    sha256 monterey:       "6b0d2f1f6b976429ab45c44136356ef99766537d9ec5c2a6b21258451d0292b8"
    sha256 big_sur:        "c47a13705ad8845390b127158b3867d4b87e95ffee4d81ae6823ea7e94ccd9f4"
    sha256 x86_64_linux:   "a9297eaace67da039b59b30f443cfc9357e328373aaf4bdc799f9d64a17eb942"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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

  patch do
    url "https://github.com/giuspen/cherrytree/commit/dacf5ba650b4495705184e63d495ac730c4e00b0.patch?full_index=1"
    sha256 "e427653dbe91e00cab0243fa996afae1bcd7fd0f97cc433e5d0a08a7941d1974"
  end

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
