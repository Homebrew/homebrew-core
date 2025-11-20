class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.0.14/nip4-9.0.14.tar.xz"
  sha256 "a5bb0eabdbf5d6d6e1522e1a26ac158ed6a2b289cf47610b8d276fb876aa7b95"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a9e00413fcbc1db51dfdb3880d06ada830c412328bc5e7c4dc5ebec0086b9bf0"
    sha256 cellar: :any, arm64_sequoia: "7092befb5e9da4c443684a50774b80f27e03cef8f9ca41e8c885f5e32dcede8d"
    sha256 cellar: :any, arm64_sonoma:  "42670e3fcc44b5f66fea3bfa702db4024cbb6df955521a5587cf416f564171eb"
    sha256 cellar: :any, sonoma:        "4c6767b749362c234648e630b20c68cc9d55251d9a52908669a8811a643721e4"
    sha256               arm64_linux:   "e07e90cf31ec1a0e84d765a2c96b93acb844cfd12d5457322036fdf6aa680456"
    sha256               x86_64_linux:  "c0d7ac6813dc75bdce14df90f79d085c636aa8591d0d9ea807fa881350050c23"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gsl"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libxml2"
  depends_on "pango"
  depends_on "vips"

  def install
    # Avoid running `meson` post-install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/nip4 --version")

    # nip4 is a GUI application
    spawn bin/"nip4" do |_r, _w, pid|
      sleep 5
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
