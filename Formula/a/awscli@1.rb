class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/db/65/356179ff8b1770f9b0052436ac2390e07ae3f2fbd8a83d137c371dac9cbf/awscli-1.37.10.tar.gz"
  sha256 "e5bbfbcbadc866a52e1e02b87b6148a5a98aa62a71cbf29aca6aec2abad9ef17"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb47973d686210f4fb71a677a9aa9b66981b8ae7214891f30245cee1cbf28461"
    sha256 cellar: :any,                 arm64_sonoma:  "9c9283767fa317d4552745698ef5d37e049889ea1f07338ae2b9b27ec8139c2c"
    sha256 cellar: :any,                 arm64_ventura: "75bd6a1ed4e04508dd62810824feb59870bd67f2fd07311519115d52bfeb0677"
    sha256 cellar: :any,                 sonoma:        "58b0bc7314506f1922fa082ce9abf42d46a6009106a4ea4c9772069584d6f3c7"
    sha256 cellar: :any,                 ventura:       "4b1a3f7d49b4083611d2e09172edb26efb96244a8408e947d19e7095748303fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02f4bae2934a26d0b022cb24a7d49f2261e8c70738abc67e03380c3ccbac636"
  end

  keg_only :versioned_formula

  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/05/da/8d21e15a1366a076c54529059c45c66943c217f1eadea5eb36791274d8d0/botocore-1.36.10.tar.gz"
    sha256 "d27bb73f0ea81395527a6298ac0a7ea5b2958094169f7cf7d48e3f4e4bc21b65"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
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
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/45/2323b5928f86fd29f9afdcef4659f68fa73eaa5356912b774227f5cf46b5/s3transfer-0.11.2.tar.gz"
    sha256 "3b39185cb72f5acc77db1a58b6e25b977f28d20496b6e58d6813d75f464d632f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "awscli/examples"

    %w[aws.cmd aws_bash_completer aws_zsh_completer.sh].each { |f| rm(bin/f) }
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~ZSH
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    ZSH
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
