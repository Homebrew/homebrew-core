class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.36/gtk-doc-1.36.0.tar.xz"
  sha256 "3b84bac36efbe59017469040dfee58f17cf0853b5f54dfae26347daf55b6d337"
  license "GPL-2.0-or-later"
  revision 1

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bda10d6a7806c4a3b900203c0ebc0f450d1c07d22b6d42ebc498a05a7b488cf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7786664f1459fd909ce570c0db2e2fb609b74f2a7455407d49750848a530b1d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e96303cfc6156115bd58e7fb591cc2366d19d917021c3f0e06b4c12286661ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "34cd092117725bb031c2c67ad8fde6a199058e8dc2b5e768e166df2bd4264d85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21626866a4655a070d0a14c02c41c7216ad9580e2f6bd60a5a351ac448546046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d92a564d508bc96a26399e8885f52ce849df7f336de73bb2be8e6fb6d59eb09"
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
