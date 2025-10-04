class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.35/gtk-doc-1.35.1.tar.xz"
  sha256 "611c9f24edd6d88a8ae9a79d73ab0dc63c89b81e90ecc31d6b9005c5f05b25e2"
  license "GPL-2.0-or-later"

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea7c25941f3bfbb28ac2474f625ceb318ffa9b50034ff72df5c0ff569a9a7257"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e08781b4c4fd57b0ffc0ccc6a6a1b549f4b5cf8c8e79d8d44abafddeeb4aa296"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "573c2ca1b61be3fbf577a089c8c4aac63891ee788ae5128082015e9eac4a8b78"
    sha256 cellar: :any_skip_relocation, sonoma:        "745fbbb1e01f680a73691abeee2fe4d9cfabd5b149f9b1f8aa0bb94af0a7f02f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d15c28ac7bbc1418aca61d0f10c53cf669b0f2b729e06d9411ed055a80139f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "209f72c9fb356cf94f65c9127f500c6a85b876743471f44ceb18b4cd9f2d1955"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

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

    venv = virtualenv_create(libexec, "python3.13")
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
