class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://github.com/jorgebastida/awslogs/archive/0.7.tar.gz"
  sha256 "614b8f6856a51cbe9677d2dfcc5b5c635916783a0dc75f972ba5a35b96359d7b"
  head "https://github.com/jorgebastida/awslogs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bdb2d38f767d73a52a14ff20851b87bae0444004aa4ed1f1f162b4dc8ad8124" => :sierra
    sha256 "855664da2786a254fa24ceb6b6ae25d6da7ab2933c19a9e2e91578a5f658547d" => :el_capitan
    sha256 "38dca2746910d2cc4900669c8c411cd77bab01397020c880cef490fddcc14fef" => :yosemite
  end

  resource "boto3" do
    url "https://pypi.python.org/packages/58/61/50d2e459049c5dbc963473a71fae928ac0e58ffe3fe7afd24c817ee210b9/boto3-1.4.4.tar.gz"
    sha256 "518f724c4758e5a5bed114fbcbd1cf470a15306d416ff421a025b76f1d390939"
  end

  resource "botocore" do
    url "https://pypi.python.org/packages/ab/cb/c609c845fa4639afde0c8cf02de8f93381dd6d73878bf9f9e5223daa8cfb/botocore-1.5.27.tar.gz"
    sha256 "1a239a4690a4bab0e0c1c85d02bbd911be3a51dc4fd583e415f79810e504da65"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/05/25/7b5484aca5d46915493f1fd4ecb63c38c333bd32aa9ad6e19da8d08895ae/docutils-0.13.1.tar.gz"
    sha256 "718c0f5fb677be0f34b781e04241c4067cbd9327b66bdd8e763201130f5175be"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "jmespath" do
    url "https://pypi.python.org/packages/96/6e/0723cccec195a37de6a428ad8879fe063b6debe5c855444e9285b27d253e/jmespath-0.9.2.tar.gz"
    sha256 "54c441e2e08b23f12d7fa7d8e6761768c47c969e6aed10eead57505ba760aee9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "s3transfer" do
    url "https://pypi.python.org/packages/8b/13/517e8ec7c13f0bb002be33fbf53c4e3198c55bb03148827d72064426fe6e/s3transfer-0.1.10.tar.gz"
    sha256 "ba1a9104939b7c0331dc4dd234d79afeed8b66edce77bbeeecd4f56de74a0fc1"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "awslogs 0.7.0", shell_output("#{bin}/awslogs --version 2>&1")
  end
end
