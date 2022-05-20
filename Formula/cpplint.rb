class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/c5/0f/4f2de12a37b1cbfefabff29ef8d529336c2ceec3226e270b369e8e52c735/cpplint-1.6.0.tar.gz"
  sha256 "8af99f95ed1af2d18e60467cdc13ee0441c2a14d693b7d2dbb71ad427074e491"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e53df3b51b59581f188be6f0256d28c85609e43b06ed5e098d7031dd5ae90db4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e53df3b51b59581f188be6f0256d28c85609e43b06ed5e098d7031dd5ae90db4"
    sha256 cellar: :any_skip_relocation, monterey:       "292ac43454d919bb8cdb7192ca564efcade87bff64ee74ef49838d881f95a4c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "292ac43454d919bb8cdb7192ca564efcade87bff64ee74ef49838d881f95a4c4"
    sha256 cellar: :any_skip_relocation, catalina:       "292ac43454d919bb8cdb7192ca564efcade87bff64ee74ef49838d881f95a4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7fb23f2c8ae546bf1a8555c6a55c6822a884f63002fae33e72efe229de89aca"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources

    # install test data
    pkgshare.install "samples"
  end

  test do
    output = shell_output("#{bin}/cpplint --version")
    assert_match "cpplint #{version}", output.strip

    output = shell_output("#{bin}/cpplint #{pkgshare}/samples/v8-sample/src/interface-descriptors.h", 1)
    assert_match "Total errors found: 2", output
  end
end
