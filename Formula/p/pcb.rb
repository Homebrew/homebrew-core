class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.3.0/pcb-4.3.0.tar.gz"
  sha256 "ae852f46af84aba7f51d813fb916fc7fcdbeea43f7134f150507024e1743fb5e"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1

  bottle do
    sha256 arm64_tahoe:    "d47e9044a1a9580a71e41ffd91541653a9b8d8c721441f0d2d63406a16ca5706"
    sha256 arm64_sequoia:  "2a52b59cc8b8207bd28cde88cc56ad797d2aa021d1cb145bffa93368a7371014"
    sha256 arm64_sonoma:   "191403f5cf3241f6322f861bf87c986a5e9e584b718694a09e8d78ffe88090de"
    sha256 arm64_ventura:  "50572577988176158590776ea433364a6198912f1a7a723894850210ed83df8d"
    sha256 arm64_monterey: "7782eb09fd3afc492dee0cf01c174076d43d57af106b0e17179309dddeb691c2"
    sha256 sonoma:         "c130c3df546d25dc2bd04ecab6bab91443a78ae03fbdc69ddbcd8cc9254cf41f"
    sha256 ventura:        "146de3e1c90e9fd5cd77cbfc9e9f803d3aeff8c15488e8c58f4131dcbd73a920"
    sha256 monterey:       "fcba66246a65011041d14e79b9374017581de797ed85de564ce79358f796caf4"
    sha256 arm64_linux:    "34ef58a579664a04a77783e8f75f4f4418b7f29de5dcdc8d1db60a030f2634c5"
    sha256 x86_64_linux:   "14d163a567ff23fb93d3c08b11c6e70d0ccd80a6897a01ffe4fdd3e112330ec1"
  end

  head do
    url "git://git.geda-project.org/pcb.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  # Original homepage http://pcb.geda-project.org/ redirects to
  # http://www.repo.hu/projects/geda-archive/pcb.geda-project.org/ which states
  # > WARNING: the gEDA/pcb project is not actively developed anymore.
  # > You may want to switch to the Ringdove EDA project which is similar in spirit but is active.
  deprecate! date: "2025-09-06", because: :unmaintained # TODO: replacement_formula: "pcb-rnd"

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "dbus"
  depends_on "gd"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "gtkglext"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gnu-sed"
    depends_on "harfbuzz"
    depends_on "libxrender"
    depends_on "pango"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  conflicts_with "gts", because: "both install a `gts.h` header"

  def install
    if OS.mac?
      ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin"
    else
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
    end

    system "./autogen.sh" if build.head?
    args = %w[
      --disable-update-desktop-database
      --disable-update-mime-database
      --disable-gl
    ]
    args << "--without-x" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # Disable test on Linux because it fails with:
    # Gtk-WARNING **: 09:09:35.919: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/pcb --version")
  end
end
