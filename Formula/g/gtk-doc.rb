class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.34/gtk-doc-1.34.0.tar.xz"
  sha256 "b20b72b32a80bc18c7f975c9d4c16460c2276566a0b50f87d6852dff3aa7861c"
  license "GPL-2.0-or-later"

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3396f660df0c1fc229771113d999afb4649f4d558db3a9b0843c4d620c8d228a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d549dac87e671dd909d3549d9d1a3b3e7ee8ba2ea0c1ba46d5d453a0799efbd"
    sha256 cellar: :any,                 arm64_monterey: "5ab3de59f7e3ceafc190662f15fec6cc6c9a39bcce9a1c8b9538ebe9fee3c7b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8693fb5823abd139140a296f79ba53f57b5f055cdf98bd373e3c8116bba5e39"
    sha256 cellar: :any_skip_relocation, ventura:        "9dac6206131a4d1eedd443daf31f8a8ca14eb9e400b4def87ee50648d8ce0304"
    sha256 cellar: :any,                 monterey:       "f8263480fbd1efa1e5bae24df626222413e2397701c2469565f395b08d56109c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af17e4d4cec00c1de69b0c1ffeff28548f7837001ea9421e16edabd1688fbce6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", Formula["pkg-config"].bin

    venv = virtualenv_create(libexec, "python3.12")
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
