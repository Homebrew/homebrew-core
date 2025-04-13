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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1f93587b00c38082d46a918917df8b1be8af308f1da1ed220ec2dbeed5cbf52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e793af38570706760f128a35323714530cd1a61e49a5be3aeb61d6a12c87026"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62aab6d8c1b15f0aa75052aa3b928304aecdb39241e1c6c4e165b6436dcfc12d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c48ba412d560fa2dab1af3f8ac98013d64e77d4ad1c47f46c9aae84fdc30cdc7"
    sha256 cellar: :any_skip_relocation, ventura:       "167239cb8ead5dcc2911212f63302b7af68d88ba38dc1996e24a9c1da8150bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ae17097732d29e71de50c9e7d8113e76447bebd0d23d3cb2e475ef543d29313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1cee5eacdfd90a89dad5a1b9303442d97fdb170bf1014efbc323d49e292f59"
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
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
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
