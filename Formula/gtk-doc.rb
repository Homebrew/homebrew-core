class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.33/gtk-doc-1.33.2.tar.xz"
  sha256 "cc1b709a20eb030a278a1f9842a362e00402b7f834ae1df4c1998a723152bf43"
  license "GPL-2.0-or-later"

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "31f6f5bc5918792ddece0aca021f8726d1fc88b76ef4e6b6ef40dd865624916f"
    sha256 cellar: :any,                 arm64_big_sur:  "6be94177308c7cb81573af6612f3bfcbf050a1539d2b2de8d8ebbde017fa00f4"
    sha256 cellar: :any,                 monterey:       "9304600335bd228e2825e875fb8d62e72e2b7d7d9bc2bcd33fe3d41d904f30d9"
    sha256 cellar: :any,                 big_sur:        "b3d2370a6a3fff63341d86c5313e238af04af84dac34a6a19d6f7a1a77acb885"
    sha256 cellar: :any,                 catalina:       "cfaf657a0e2b8ac879deaefbd2361a2fe7a8e9b3234f73d0ad32eaa5be4a6beb"
    sha256 cellar: :any,                 mojave:         "abd68d022b9e19677a00c397fc316370b2106133f3a37c9f9c8b13e2d6b099a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415526676543d0f3899bd76944217912d9e37387b0039ee830c887fec03b6ad4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "libxml2"
  depends_on "python@3.9"

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

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    ENV.prepend_path "PATH", libexec/"bin"

    args = std_meson_args + %w[
      -Dtests=false
      -Dyelp_manual=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end
