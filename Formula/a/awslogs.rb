class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://files.pythonhosted.org/packages/15/f5/8f3bd0f4a927b1fbb3a5e6a5b036f29e4263977fb167b301bc4a5f4db2b9/awslogs-0.15.0.tar.gz"
  sha256 "19f223bb1c0703cea0689d94b1d293006529095e6ab8971f6b52289a2e545dd5"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/jorgebastida/awslogs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a97f96ed5fbb4c6098714bd699d751a56134cec449f22d4e6aa96b9c8e8ec4d5"
  end

  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/0a/37/78c630d1308964aa9abf44951d9c4df776546ff37251ec2434944e205c4e/boto3-1.43.6.tar.gz"
    sha256 "e6315effaf12b890b99956e6f8e2c3000a3f64e4ee91943cec3895ce9a836afb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/79/a7/23d0f5028011455096a1eeac0ddf3cbe147b3e855e127342f8202552194d/botocore-1.43.6.tar.gz"
    sha256 "b1e395b347356860398da42e61c808cf1e34b6fa7180cf2b9d87d986e1a06ba0"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/9b/ec/7c692cde9125b77e84b307354d4fb705f98b8ccad59a036d5957ca75bfc3/s3transfer-0.17.0.tar.gz"
    sha256 "9edeb6d1c3c2f89d6050348548834ad8289610d886e5bf7b7207728bd43ce33a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/46/79/cf31d7a93a8fdc6aa0fbb665be84426a8c5a557d9240b6239e9e11e35fc5/termcolor-3.3.0.tar.gz"
    sha256 "348871ca648ec6a9a983a13ab626c0acce02f515b9e1983332b17af7979521c5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version")

    assert_match "You must specify a region", shell_output("#{bin}/awslogs groups 2>&1", 1)
  end
end
