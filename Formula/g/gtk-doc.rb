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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67a09406091e040819bc13b3058556a515aa928f4e4bc8b198a7bfa121dc3ecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e454c447eff2b55455f9982a4ab9a702f0dd51c593a771be9dcae29ba146366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "866c6675c4c79ff241b06f491642c9eadfc85a653cd74f699bc46cd474324d79"
    sha256 cellar: :any_skip_relocation, sonoma:        "3490738954bfbe69c87b197747607ecba230cd5a418bee8264a1903a4f32e9e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "649ef0b77f32d76501c7f8932e4dc82720c7f7b1a2f10ebc352a7225d0a688ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4843c19d63f4d41befdc171adf726bcec1255b2781c328795b0e5d40456d405"
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
