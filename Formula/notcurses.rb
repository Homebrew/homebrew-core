class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.3.13.tar.gz"
  sha256 "c5eb822ea5b98028acd4a8dd21b155f893d928e4a30a8309eea0c406403af4e8"

  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "0399de22b50be2ea952ad6a01ea047465442abdc15b8e016a077bc6bc4f8f599"
    sha256 big_sur:       "936449cc8f5b918fb4bd4791b640e1967b1952c56d3f95d734aa361e4708862d"
    sha256 catalina:      "3c686e777c54780349651046f7cdd6c154d44489f3db972559dfb8dc0dc47c7e"
    sha256 mojave:        "877eb6ba861bd07faba401ac913b145013386b1dbe7c18a181a4eccc676f68db"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libunistring"
  depends_on "ncurses"
  depends_on "readline"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # without the TERM definition, Notcurses is like a small child, lost in a
    # horrible mall. of course, if the tests are run in some non-xterm
    # environment, this choice might prove unfortunate.
    # you have no chance to survive. make your time.
    ENV["TERM"] = "xterm"
    assert_match "notcurses", shell_output("#{bin}/notcurses-info")
  end
end
