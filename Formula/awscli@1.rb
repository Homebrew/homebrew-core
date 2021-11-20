class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/32/2d/a4e09a2964dabcc51232c8d90bc363491f9ff81f4947409030a05f87ad06/awscli-1.22.10.tar.gz"
  sha256 "0dd718a1a2f90e98f01a52969d04a9106eac185dfa5d67f3289ecdbbde13ff0d"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a62679da95edd7fefba58f0a63acaad9438700a207e652d94ae084589aebcc64"
    sha256 cellar: :any,                 arm64_big_sur:  "1bab24fc81532bfde4d771b0e748bfcfc445b564c5cc0c7c8d7f71c3fa0a16d6"
    sha256 cellar: :any,                 monterey:       "34776f336e3f6cd1495dbb019095643fc0bb01787ace39968b5544fd07d1978f"
    sha256 cellar: :any,                 big_sur:        "dbd2c01222f966d9781a998f7863c061474f20e957c2d33ec79ad6c8d7506b9d"
    sha256 cellar: :any,                 catalina:       "18edced12ded8868ee284439f31dae9a8fb9aba437b1200ea218aa4d78a865e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25f8a6a8d86d48a0fe46a6f73645f1a6c3bb80287b116d022b8509fb2b34aa95"
  end

  keg_only :versioned_formula

  depends_on "libyaml" # for faster PyYAML
  # Some AWS APIs require TLS1.2, which system Python doesn't have before High Sierra
  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "groff"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/26/79/ba027d96c5a670fb0715f483afa4eff5ecb2456aba302b7367b12b282453/botocore-1.23.10.tar.gz"
    sha256 "0adda9a4a95221027312eaaee0ec9fe2239fb2f285fced3ddca54b1310b864ee"
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
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
