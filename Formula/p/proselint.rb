class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "https://github.com/amperser/proselint"
  url "https://files.pythonhosted.org/packages/a2/be/2c1bcc43d85b23fe97dae02efd3e39b27cd66cca4a9f9c70921718b74ac2/proselint-0.13.0.tar.gz"
  sha256 "7dd2b63cc2aa390877c4144fcd3c80706817e860b017f04882fbcd2ab0852a58"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ed17aae83ab4db2184a89ed428f0f55e7460e81f549e74b3325d966f7dc4df5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e6e0f868c31a9a934209e57c5a3980450af0c8fe44f6bb61edfdfb6b71d6c6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be71ca3ef347306463ab8aa9bd64e1a53a5511776268683853cc0175e5f9d676"
    sha256 cellar: :any_skip_relocation, sonoma:         "61131b05955cc82a2f168ef03f21cda3e5f312313a11841b78c92a825e3356b0"
    sha256 cellar: :any_skip_relocation, ventura:        "6ea888644c7b7e7f21104ab2360d004db60011764c048a52a3848f9986787a4d"
    sha256 cellar: :any_skip_relocation, monterey:       "75436637988d1f5e7dd286c2cddb563b4b13e82c210276c3f04e006f8f7ff844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "207764a7a35aef6ffda10dcbba76e5cd3b54e2662ec6e8e5ff091fdee6679e35"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match "Comparison of an uncomparable", output
  end
end
