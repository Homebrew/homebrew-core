class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/e0/8f/068476683a9ff258cf9664c614aa0b48380607d4f99637b42ee7f9ea9aef/awscli-1.27.30.tar.gz"
  sha256 "26ce22bff9d435ad6d1c9b5c310a31d447f86ed447322d7c1c571df96e37d3e9"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbd3ae85558f4a1c2ffb2973cb9fcd967ef0435c5fa40319d923374a4b2153a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "848ab1e51c75181f106ac8fc66bc51209959bd0a854584d5f91889c18c72be32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc9a5e503c8b1e6712de2a6475e7c324e9758a5a290b54544f4b2d1ea404e6e5"
    sha256 cellar: :any_skip_relocation, ventura:        "b3e354f82ebab7be7dc6df3bbf092bbd8b1f17b44287a82fd4514037b3a7d826"
    sha256 cellar: :any_skip_relocation, monterey:       "3ff090243feed8cc013119ed7608cca789a92906ed388669be627b06c30a241a"
    sha256 cellar: :any_skip_relocation, big_sur:        "702d0ab8d4a968079375867bb3b525a2e0466c78d70215110c81965ee80788c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7a09fca21b2a8ecb14a1c33aa08ffbc0b5df35681ae39c6c33bee47579d1b3"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  # Remove this dependency when the version is at or above 1.27.6
  # and replace with `uses_from_macos "mandoc"`
  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6d/36/b08a5873f03f1462975d891245a5966caee248d04d718d47681b24ab1e7d/botocore-1.29.30.tar.gz"
    sha256 "9364417f53842167f8bcf72b9ab3c78457c7df613051101952b2470d9de7ea31"
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
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
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
