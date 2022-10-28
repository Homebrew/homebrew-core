class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/df/e7/7ec9fc00cbb7b1ecf7c6d2a3647540ef31edb1cc96c8d90bc09e4a90242b/awscli-1.26.0.tar.gz"
  sha256 "3c5d24e30d6bf2e8001cd5e1f025b1f444fb6e77daf0d8325f9669d56b1f0e12"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b53136b0ba0b04f4eb6b4e44f61045ea5b72e4547c56717f9f668c5ca86a0455"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f6e0907fd73ea5ef2921c4f569fb1fe9ec3372aaae3b975288005fe9a805dc7"
    sha256 cellar: :any_skip_relocation, monterey:       "40377b4bc369b97b64145e1f351e643c8fcefdac7e1bc4c9e5da0778ae23b335"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7dd58e9650a53dde3ad6322a30d1c0c28962527f9a2427bad34d7c42ee84c1d"
    sha256 cellar: :any_skip_relocation, catalina:       "dfd3067d49e7b84d9c2dcb0872be50388ecff7da4d09a59a6313e75f412e58f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fe98501691c63d94a5dfa40da42d39c0032a6313890351395ccd4e07a4d9e3f"
  end

  keg_only :versioned_formula

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a0/1c/730fa371407c2016218765d5b34d679b7cdfc48a99564bb258b16b5ffcb0/botocore-1.28.0.tar.gz"
    sha256 "75a4082543e2c1b005ccde90af87d0969003db06c3fcbe8a7854ddaa8d68fafb"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
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
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
