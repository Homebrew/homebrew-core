class AwscliLocal < Formula
  include Language::Python::Virtualenv

  desc "Thin wrapper around the `aws` command-line interface for use with LocalStack"
  homepage "https://www.localstack.cloud/"
  url "https://files.pythonhosted.org/packages/7a/71/591a30da6819c96deca2286f145d5982e73b11e7f657e8cbfc5e003ca73f/awscli_local-0.22.2.tar.gz"
  sha256 "07c532c372753bf5f15426451dc91d6eec9de8779748049329a9a882bdac8a0b"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, all: "01ea4917355263c817f7a6ed4fc8bda4a4f42574b27b0c66915cc627d355129e"
  end

  depends_on "awscli" => :test # awscli-local can work with any version of awscli
  depends_on "python@3.14"

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

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/44/79/d240524248f0e675982c52586d67ea5030cf7511af9dbc8814e1d100cd15/localstack_client-2.11.tar.gz"
    sha256 "1cbd7bf1f03b9b553ffe7ea10fe137f44e8d690a37af9c6515eba61a2379fc46"
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

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/awslocal kinesis list-streams 2>&1", 255)
    assert_match "Could not connect to the endpoint URL", output
  end
end
