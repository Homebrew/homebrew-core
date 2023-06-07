class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.3.0/pcb-4.3.0.tar.gz"
  sha256 "ae852f46af84aba7f51d813fb916fc7fcdbeea43f7134f150507024e1743fb5e"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/pcb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "20a606566fd0c8b018cdd0dd4ca211d099818286e0ebbdbcd157e721e38aaedc"
    sha256 arm64_monterey: "71f5ca60f422ffc8d6555560f37167aae20a07c103c35fa3d100feafb9a9bc01"
    sha256 arm64_big_sur:  "41a14f1d1a3439469248dd6b58535c082f084376a90ecf3ccca2513e70cd2028"
    sha256 ventura:        "0a58696e6e8bef6689734d98d79644535cf34aec2616b120c587124a6daaaa90"
    sha256 big_sur:        "f73590271ddcf104d25fecad90c916e4d535a5041280a1bbd661acdafc806b24"
    sha256 catalina:       "a8937f1ce318a6472532eae067dc581ddef61518a5b56db83883cb2119c2bf32"
    sha256 mojave:         "0607471efce526eb3fd06286f28fa664276ab8b4c3f407b14e18eb3c426cad59"
    sha256 x86_64_linux:   "96a5bd2ef750cb1ae31604bb9f2e78daae83d9e20d7f432fa656601471465370"
  end

  head do
    url "git://git.geda-project.org/pcb.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "gd"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "gtkglext"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "gnu-sed"
  end

  conflicts_with "gts", because: "both install a `gts.h` header"

  def install
    if OS.mac?
      ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin"
    else
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
    end

    system "./autogen.sh" if build.head?
    args = std_configure_args + %w[
      --disable-update-desktop-database
      --disable-update-mime-database
      --disable-gl
    ]
    args << "--without-x" if OS.mac?

    system "./configure", *args
    system "make", "install"
  end

  test do
    # Disable test on Linux because it fails with:
    # Gtk-WARNING **: 09:09:35.919: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/pcb --version")
  end
end
