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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "6824129113a3e8577f5dfee562853cf1f00e834d7929bf500949a5d6ced5704a"
    sha256 cellar: :any,                 arm64_ventura:  "96955b74b7fccb3f0f706b15a107285cf03e43f804a2e41526a738145e77b270"
    sha256 cellar: :any,                 arm64_monterey: "b9e301121bc9914897d199bb7abe589694af195007ea3d2aec010cdc4d49d218"
    sha256 cellar: :any,                 arm64_big_sur:  "5901f5691e8af4105120f00d03aa8635a11847829c2e17db9e17e01600526c7a"
    sha256 cellar: :any,                 sonoma:         "9ab5a1e798529b2101933d46ca1a1b648bf887fe33e8c8751d531ca3cabe1002"
    sha256 cellar: :any,                 ventura:        "e8838902bc81cca0682667aca9938d3a554d79bb197e66b872f4dc3f6c2def44"
    sha256 cellar: :any,                 monterey:       "29be313fb5cd4739dc70b1d921298389b5b16fac5d9b6c38ee8eb423da76ac15"
    sha256 cellar: :any,                 big_sur:        "9070e3c3d36763fb9f60706146ccd6dbbb7cc799cf3740e728a77335b7b31ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ed7f1638539dd81611373da2a0339ea343d6a0588c695d1514da7511086c4ec"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "libxml2"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six" # for anytree

  uses_from_macos "libxslt"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
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
