class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://files.pythonhosted.org/packages/15/f5/8f3bd0f4a927b1fbb3a5e6a5b036f29e4263977fb167b301bc4a5f4db2b9/awslogs-0.15.0.tar.gz"
  sha256 "19f223bb1c0703cea0689d94b1d293006529095e6ab8971f6b52289a2e545dd5"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/jorgebastida/awslogs.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b705f89824369179c2e868aabf5639c06545dab9cff39c267f55f87478a7328e"
  end

  depends_on "python@3.14"

  uses_from_macos "zlib"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ba/41/d4d73f55b367899ee377cd77c228748c18698ea3507c2a95b328f9152017/boto3-1.40.50.tar.gz"
    sha256 "ae34363e8f34a49ab130d10c507a611926c1101d5d14d70be5598ca308e13266"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/5b/66/21d9ac0d37e5c4e55171466351cfc77404d8d664ccc17d4add6dba1dee99/botocore-1.40.50.tar.gz"
    sha256 "1d3d5b5759c9cb30202cd5ad231ec8afb1abe5be0c088a1707195c2cbae0e742"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/ca/6c/3d75c196ac07ac8749600b60b03f4f6094d54e132c4d94ebac6ee0e0add0/termcolor-3.1.0.tar.gz"
    sha256 "6a6dd7fbee581909eeec6a756cff1d7f7c376063b14e4a298dc4980309e55970"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version")

    assert_match "You must specify a region", shell_output("#{bin}/awslogs groups 2>&1", 1)
  end
end
