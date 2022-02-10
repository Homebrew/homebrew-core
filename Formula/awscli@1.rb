class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/6a/d4/6921837b93a514e471c645a52fec9fe8960700bdb71ea987d81a7bb201e3/awscli-1.22.50.tar.gz"
  sha256 "9242401e539d62d9828e3168aebfd526bd64b2ad181fae007f7d8af26415b485"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6c23310b50d9a26bb1c865de3f031519cba6a80d57c1a9668a9afc56a2fa03dc"
    sha256 cellar: :any,                 arm64_big_sur:  "c7b36197dcc0c21bddc76c9951919bcecfcd35f22c8d2218f614ba019fbca913"
    sha256 cellar: :any,                 monterey:       "39120c737d254a6f87a77b47fe80fae0aa914b29b7338415dc978077b01c72bd"
    sha256 cellar: :any,                 big_sur:        "e4a62d06ccf6139b826b05802f0a4bb80e7eeb6aea53018a770e3b411c05618e"
    sha256 cellar: :any,                 catalina:       "dcff864d7704b46d1534804fd7874591d259f08ea9e161008c97fc9add854e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a02355518a790c475a96ef1e30bc0d547d68cb48107a423e88e9be16cd8d571b"
  end

  keg_only :versioned_formula

  depends_on "libyaml" # for faster PyYAML
  # Some AWS APIs require TLS1.2, which system Python doesn't have before High Sierra
  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "groff"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/39/50/eca036b0c44e6826a49e743095e009d533f3fb81bdbf871eb5f5766fe56c/botocore-1.23.50.tar.gz"
    sha256 "109d9a200f70268d5429423fd8052f6fed5e041853d6621081692ea5ad7f70c7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/66/e2/cc19f36aade1ef40cba69555fcf713d942ec9e31ecff2415948bd885911d/s3transfer-0.5.1.tar.gz"
    sha256 "69d264d3e760e569b78aaa0f22c97e955891cd22e32b10c51f784eeda4d9d10a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  def install
    # setuptools>=60 prefers its own bundled distutils, which is incompatabile with docutils~=0.15
    # Force the previous behavior of using distutils from the stdlib
    # Remove when fixed upstream: https://github.com/aws/aws-cli/pull/6011
    with_env(SETUPTOOLS_USE_DISTUTILS: "stdlib") do
      virtualenv_install_with_resources
    end
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
