class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.3.12.tar.gz"
  sha256 "ce042908fac11f7df1f9eaa610e46e9c615f53ab036b7c27ae2396292512407b"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libunistring"
  depends_on macos: :catalina # requires std::filesystem
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
