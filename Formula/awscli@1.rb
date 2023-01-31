class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/ed/91/bf0cf6451724d3e7693f288441268ced94ebe01938c9a4a23b2f644b355c/awscli-1.27.60.tar.gz"
  sha256 "6ef5d5e846fe87e9c949e2fd4bbbeea832215dfcd650b4526a131e4626121bd7"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d1a34b03e2f99aae7462d10e9302544c8c038a4ace40f213975a61b235273cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41b06cbef2d8b75d13c205c8ea144a3473b4e200f73dbeda33b6a66ade4fee02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6b92f64d9995288fcc5625ef93c9b0758f145550d3fe81df24734475988a973"
    sha256 cellar: :any_skip_relocation, ventura:        "4da3326e6a90cccc9a763eb10de976f8aa914304d6b5b943cf11032206f18600"
    sha256 cellar: :any_skip_relocation, monterey:       "02f9554e7a7288540e6fbc6659a320ab1f13a724ab9e1ac34c6cd45b5862160d"
    sha256 cellar: :any_skip_relocation, big_sur:        "410be6ccf485a998153e8a1f464628990b076114f7012ddc3ebf0974ae57d559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "654d594c04ac55cde62b6fe4805a11747c0f02836f1760374cfbf33ee08b06ab"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/dc/0c/7377983853fb50de53d409c82466bacf86d0273b3f0ebce070b00388f731/botocore-1.29.60.tar.gz"
    sha256 "a21217ccf4613c9ebbe4c3192e13ba91d46be642560e39a16406662a398a107b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
