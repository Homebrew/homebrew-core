class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/45/9f/6ecdff7f0f0fdd019844951d85f253b2dae74b6c5ca6902e66f9b62f6646/awscli-1.29.60.tar.gz"
  sha256 "a96a7db174dbdfd9338aa5459a75d11ae14f7e242181b440dda6776af0143f3a"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d296e791211068e18221da0529d19e3fb354a6238fda5f777dfe31046410b484"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a429ace94467a0e3e1e5932e8a1c02c0d7400cb07f1048bfd4387dd2b37d0879"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "781fda65735ab24ceca4b9e5bfc1270a66297e1c29417184c68d262cdcaf3825"
    sha256 cellar: :any_skip_relocation, sonoma:         "86f9690ac82618ecb554926db545df5f57d32c1b18063122feb4db9915b7ec86"
    sha256 cellar: :any_skip_relocation, ventura:        "6759614e9c118c50671226829037ba4d75e6055aa5bc35645a645c356b56e8a7"
    sha256 cellar: :any_skip_relocation, monterey:       "bf7263bb175f794e866bacbea4690a72f2ec7d04ffbae98fac1593a6b6944bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "212037a144b50871a7215eae3b568d069e55d630e29872bf155b84c7270b6514"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/33/4b/c9fed0cfa7056492e24cd0fec2ed4cb41f75fb480dcb931840290823ab20/botocore-1.31.60.tar.gz"
    sha256 "578470a15a5bd64f67437a81f23feccba85084167acf63c56acada2c1c1d95d8"
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
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
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
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
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
