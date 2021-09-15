class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/70/d5/3792cd3cf5681b8d8bc145c55812c2462e42b497e2f12b76bda6d81d965c/cpplint-1.5.5.tar.gz"
  sha256 "18e768d8a4e0c329d88f1272b0283bbc3beafce76f48ee0caeb44ddbf505bba5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08731fd0f48c494b903cc4d56565595e7005cb7c2187d6480a9390ac28f107dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "d0582e4c96974e6078c385f8c2fd3bcf754bf4d66c55241566c9e7c567dd9aec"
    sha256 cellar: :any_skip_relocation, catalina:      "d0582e4c96974e6078c385f8c2fd3bcf754bf4d66c55241566c9e7c567dd9aec"
    sha256 cellar: :any_skip_relocation, mojave:        "d0582e4c96974e6078c385f8c2fd3bcf754bf4d66c55241566c9e7c567dd9aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0011ea0fff4ec9c6ab2968b532ebd70a4cbc4d4e74efe84518f3ae88789ee8fe"
  end

  depends_on "python@3.9"

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
