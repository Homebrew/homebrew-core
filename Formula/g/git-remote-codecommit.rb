class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/ea/58/71a6047949f07a75ea7e1d273ba1c126e03c69f17a910d837f9368bc8dce/git_remote_codecommit-1.18.tar.gz"
  sha256 "a34b737b0bd4b52932fd12cc42b3dfed5a7e4d87b5bc24910b90bf6e0f42f580"
  license "Apache-2.0"
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "799a0401214822d31ac9248b0b2c536f101393e8ff8f9b075b5ee4aa0ade3419"
  end

  depends_on "python@3.15"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/09/f4/ca9bcb9774e8d0a903b95743abb252c78d05d80faa97eb6ee7f9c7167e0b/botocore-1.44.5.tar.gz"
    sha256 "a988f39e3a4484def0b8010f41128f71157da0515a4804fccce4739aa8f216da"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end
