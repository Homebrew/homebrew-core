class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.36/gtk-doc-1.36.1.tar.xz"
  sha256 "0e517a5f97069831181be177516bde8aa8b3922398f2bdb09e265d22aecadbc5"
  license "GPL-2.0-or-later"

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92b3de960f05cd6aa078168d15c29ee98bba3b1679ecce31fe297744c862df13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3a225d00d74c528c3f9a32962a7128d2142d36b9bd5f420d53dac13abc636ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bfc2fe13b5c29fa9ba41678d387c62b8a26bea00d4e0fe1aec7c3dc00b2f312"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c9e18e7d679c43b6cffa7a6ca0190a1fbb22b1d25e6ffa6186793ccba22beab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "995bbf1b30cb3269bed346ce9fbce436d17a56cba373b986c961dccb3558ab2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37296c2c2a71aa6e6e5a90b6091da7fa8f2c7463d5f27ae26c777a858cace6e8"
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
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
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
