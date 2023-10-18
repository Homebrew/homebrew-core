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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3afb405fa87b3a9f5941a309df3324f321a90bb24fbd7dfb77b167eaa935d3b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b91f5788ff06df5f60b16c7605fad3b8a5d79bee26acaa2b19e68d53074ea2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c9fc2e3043e496c91d493bfeb63674084755a36e16dc92e4aac61084cd0cc97"
    sha256 cellar: :any_skip_relocation, sonoma:         "485eada6f6e9cb02f341b9e6cb8a56c04f89b91c999032c33e943775ec837cc8"
    sha256 cellar: :any_skip_relocation, ventura:        "ed131246acbddedd184a939ff78a612cb868611f532eeeb7a4ff94bd11f16db8"
    sha256 cellar: :any_skip_relocation, monterey:       "ff95b1fdc87a87444d779daf595a0dec88ac906baa04683d41fc171f4b09a183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05966d470e6ec9eb3ae8a08f0fc3117f4036e952308b52f717f57121feb9b2f4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "pygments"
  depends_on "python-lxml"
  depends_on "python@3.11"
  depends_on "six" # for anytree

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", Formula["pkg-config"].bin

    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    ENV.prepend_path "PATH", libexec/"bin"

    system "meson", "setup", "build", *std_meson_args, "-Dtests=false", "-Dyelp_manual=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end
