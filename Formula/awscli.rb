# Make sure that you also bump botocore
class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://files.pythonhosted.org/packages/6c/86/64d343393526bcfc6d3142ef0f9eab879d78383f5ffd0f43910519055ffa/awscli-1.10.59.tar.gz"
  sha256 "270b8d7626f398e5867d777b75d16d0d48154d28e45dd309ac96597fa35c15f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "0eb2fe8272937674ec8c0f6a023e918e082ba76da51d34f16a18efa99203b4b5" => :el_capitan
    sha256 "eebdc2bac588c3bee7ff8007599a65b3cf89b4cecadf30c27b7958216c093c6d" => :yosemite
    sha256 "c3e10308f8c92c1647217d8c6ed29690f5a839835ea4697de52ae8b9662061d0" => :mavericks
  end

  head do
    url "https://github.com/aws/aws-cli.git", :branch => "develop"

    resource "botocore" do
      url "https://github.com/boto/botocore.git", :branch => "develop"
    end

    resource "jmespath" do
      url "https://github.com/boto/jmespath.git", :branch => "develop"
    end

    resource "s3transfer" do
      url "https://github.com/boto/s3transfer.git", :branch => "develop"
    end
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/55/9d/9f118d87220121bf3028317853236b1d2e6e27ba4600bf67a8bbf17a2bfe/botocore-1.4.49.tar.gz"
    sha256 "c7804efb622f340593ae49cc552481f2820de2088199a0010d469cf0dfb94731"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/37/38/ceda70135b9144d84884ae2fc5886c6baac4edea39550f28bcd144c1234d/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/8f/d8/6e3e602a3e90c5e3961d3d159540df6b2ff32f5ab2ee8ee1d28235a425c1/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/14/89/adf8b72371e37f3ca69c6cb8ab6319d009c4a24b04a31399e5bd77d9bb57/rsa-3.4.2.tar.gz"
    sha256 "25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/b1/04/27bfb9ceda7dad27c32cc6c260371d56d97b733fb4ad6fd5b01c1b75900a/s3transfer-0.1.2.tar.gz"
    sha256 "779d0cd9aa30fa65c6e8da8dc203d165ef7aa6cab0b7faa502b850e6cb9236dc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources

    pkgshare.install "awscli/examples"

    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh" => "_aws"
  end

  def caveats; <<-EOS.undent
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples

    Before using aws-cli, you need to tell it about your AWS credentials.
    The quickest way to do this is to run:
      aws configure

    More information:
      https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
      https://pypi.python.org/pypi/awscli#getting-started
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws --version 2>&1")
  end
end
