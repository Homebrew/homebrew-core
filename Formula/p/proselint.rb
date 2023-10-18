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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be448af58ff0d1b30c121d0fda4e3b5da67ff8b6020e821873db48c81875c4b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc6962aeefd2c56637375e63f9d39657305b92dd247327c358234570a7767f7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a3afaef5e02bf8bf60359f0cc3436ccdea2a92e80148a4f1a5c466debcb4bbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "58ecd6b139a4ddb67925c340ce4f9846e527e64d50869f0f7db0b0669d6678dd"
    sha256 cellar: :any_skip_relocation, ventura:        "102805d2ac9d185255183c75377761b23b836cec6085eafc1fc6d842b2fb03fa"
    sha256 cellar: :any_skip_relocation, monterey:       "f6279ef869ccbf9005cb1ea19121979cabfc07bf049a1af9c4ecf3e891af6035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "360c46bc07f68964b03757e66a7b2eab0a23d423911e1354862aaf055ff91d1a"
  end

  depends_on "python@3.12"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match "Comparison of an uncomparable", output
  end
end
