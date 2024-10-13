class Beancount < Formula
  include Language::Python::Virtualenv

  desc "Double-entry accounting tool that works on plain text files"
  homepage "https://beancount.github.io/"
  url "https://files.pythonhosted.org/packages/bb/0d/4bfa4e10c1dac42a8cf4bf43a7867b32b7779ff44272639b765a04b8553e/beancount-3.0.0.tar.gz"
  sha256 "cf6686869c7ea3eefc094ee13ed866bf5f7a2bb0c61e4d4f5df3e35f846cffdf"
  license "GPL-2.0-only"
  head "https://github.com/beancount/beancount.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd46704b5f7378d8f22c21d28dd7889e5c4128e74fffad77abbd15c97690e0d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3156bab6cb30a56af2bc10fde877271be206952204334f8cf6623e56baa37a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53f9b70c1f228ae55aa911283407a2d2eaa535e9da434270c9e8328371c345a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ee09aef497ae1937ef164f58f2894704b3fb0a362d01e42cd877abeea23a9b0"
    sha256 cellar: :any_skip_relocation, ventura:       "9c8678874984a80f6df58b18f09bf90bc73cf180421299b403e7f91e062c0298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6052aec81c41e933c8ba47c69673e45539088e07282b0b91dd5128c97acbb6af"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.ledger").write shell_output("#{bin}/bean-example").strip
    assert_equal "", shell_output("#{bin}/bean-check #{testpath}/example.ledger").strip
  end
end
