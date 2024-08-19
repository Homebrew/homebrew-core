class Beancount < Formula
  include Language::Python::Virtualenv

  desc "Double-entry accounting tool that works on plain text files"
  homepage "https://beancount.github.io/"
  url "https://files.pythonhosted.org/packages/bb/0d/4bfa4e10c1dac42a8cf4bf43a7867b32b7779ff44272639b765a04b8553e/beancount-3.0.0.tar.gz"
  sha256 "cf6686869c7ea3eefc094ee13ed866bf5f7a2bb0c61e4d4f5df3e35f846cffdf"
  license "GPL-2.0-only"
  head "https://github.com/beancount/beancount.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10405080e1d55734bd3aa6ba0b53a0063d7cbf6314b82aac46b564a00415569b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88055566d5a2da9aec14830ff8aa30be1c7cddb140462aa7282665b7d20bdaf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d2bac775d648799b393f5d5992ada6d139bed9c6e6db1d7749747dc4d7fdf7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "34f13ed6f8e78f2aed71aa0d44956807241ec58477f3024e253cfa82192729a7"
    sha256 cellar: :any_skip_relocation, ventura:        "22d828be5a46d46de8049d88f34fd605b445b2b7cb8c8c45aef417e6f568048d"
    sha256 cellar: :any_skip_relocation, monterey:       "70dc527ee42cb1691cf7e678fcda1fc5ef63f044b187a7a96f8b8081dc488e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e60fa9af11396db901daac24e910ed49c3f45186c1e6ecbb7565e54fce84f090"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "python@3.12"

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
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
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
