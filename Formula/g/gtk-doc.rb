class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.36/gtk-doc-1.36.1.tar.xz"
  sha256 "0e517a5f97069831181be177516bde8aa8b3922398f2bdb09e265d22aecadbc5"
  license "GPL-2.0-or-later"
  revision 1

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10ffbf3cbe6b5a3aa9707a9ac01c256b208a92f179fa279ba1c42aa641bc36c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faf1207cdda1baeb9fe4b6282394afc9465ac6192d356315ec3f590a5f354896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e1d337546ff4c8dda08e1d70069985675009c2c88e1c510c5b278e6bf62ee29"
    sha256 cellar: :any_skip_relocation, sonoma:        "4899cf390c65bef2d73d072f1a228bc2def11be1480e4a2f74f23609bf439325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf876fe048491a3d10bd980e4022ac7cce4761a931651b29d85606a0bb06fc33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dfea56e91394088e0dc7b8fc79a56810342b8981c86a3b45eec0baca3aa6b2a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages package_name:   "",
                extra_packages: %w[lxml pygments]

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", Formula["pkgconf"].bin

    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources
    ENV.prepend_path "PATH", libexec/"bin"

    system "meson", "setup", "build", "-Dtests=false", "-Dyelp_manual=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end
