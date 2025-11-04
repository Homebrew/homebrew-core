class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.35/gtk-doc-1.35.1.tar.xz"
  sha256 "611c9f24edd6d88a8ae9a79d73ab0dc63c89b81e90ecc31d6b9005c5f05b25e2"
  license "GPL-2.0-or-later"
  revision 1

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a90c3d33110464699a6c11e6a01ba0cea2e780ab6cae064364ccaba924607ae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c323f71e2b55623ccb7d8235bd79f04bd02b8e5b435aeefa35093cc0f2f1fbcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ea95bfdc68fc15762a49339006d88e2292f5fdcc790c41aa1665dd7d785eaaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8058ae6f1c944ebc5c11e8154c0dabdc6b18fe200b9125f55416bc8ecb84473"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8290d097809af9fb72aeea7aaca594ecbc170ae542c677508e1a394956d575c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06bc0e0c42aadb3c4c90e6f4f68296e1da0c23a9311bfa3cf0ae6b1e25c8a7f9"
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
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
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
