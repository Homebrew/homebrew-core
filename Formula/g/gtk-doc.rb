class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.37/gtk-doc-1.37.0.tar.xz"
  sha256 "2facfb530ddcd20c03ed4758ef934e832626c393e2cacd23fc1249b7ed0e4246"
  license "GPL-2.0-or-later"
  compatibility_version 1

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13ff63b764076b1127f04a2695abb91780a770207368865682289962569db2fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a9b23408f1392435c126035a9e42f6232325b45e074be2e25cd43ef90ae9f7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cab42481acb3dabc5eeed76a1e7e83414e076e166c55b977942525db3906cdea"
    sha256 cellar: :any,                 arm64_linux:       "d268e62d73609cf6042ad6aa21d9287f3b7d7ecb0ea90d0c314eae71dd7c6b99"
    sha256 cellar: :any,                 x86_64_linux:      "d7e000cc817fac51e8effc326ce52e9d09fade155a4c81f65051ace5292b3e91"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "python@3.15"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages package_name:   "",
                extra_packages: %w[lxml pygments]

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", formula_opt_bin("pkgconf")

    venv = virtualenv_create(libexec, python3)
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
