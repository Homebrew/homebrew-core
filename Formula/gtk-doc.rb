class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.33/gtk-doc-1.33.2.tar.xz"
  sha256 "cc1b709a20eb030a278a1f9842a362e00402b7f834ae1df4c1998a723152bf43"
  license "GPL-2.0-or-later"
  revision 1

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "93e6aed51806396d5e3a18b9fefb7312f8764f8ea0bfffc79f2cd3f4f2d02f83"
    sha256 cellar: :any,                 arm64_monterey: "0b3951853e56b258fe93abc736c0abfec944df20a94776a822ed87fd93465c79"
    sha256 cellar: :any,                 arm64_big_sur:  "cb797d7ebc987004400d9b1b8d3d8e4cfbf2515f1055d429690c4e5fc6c16316"
    sha256 cellar: :any,                 ventura:        "88e30e6d48f09f41e7e2161c223a5588d48f4a7a77dd449b268ba301e660c6b9"
    sha256 cellar: :any,                 monterey:       "374f73b607a5a32880a33cc0e16835b2e10fbdd01ad65e36c161e08ffa474055"
    sha256 cellar: :any,                 big_sur:        "2c4e4cfd3d011f378cc81a834ad6f99bfff064816174ab79832755e4cda377c4"
    sha256 cellar: :any,                 catalina:       "7fb74f0c48a48ea46e995e0ee3ec03a25b39797d142007b53af39cf926176d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "570caa1bc418c9384b16fe4f239fa2266951e6869aad93dc55cde00f01fb1862"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "libxml2"
  depends_on "python@3.10"

  uses_from_macos "libxslt"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", Formula["pkg-config"].bin

    venv = virtualenv_create(libexec, "python3.10")
    venv.pip_install resources
    ENV.prepend_path "PATH", libexec/"bin"

    system "meson", *std_meson_args, "build", "-Dtests=false", "-Dyelp_manual=false"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end
