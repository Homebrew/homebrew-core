class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/37/c7/6c0f664d8da301768bdf5ba330a85ca6dd075d1bf334df7b6766e060f6b1/awscli-1.43.0.tar.gz"
  sha256 "dbc1d75eb7fbd6cb042788162228670e5f71027d4fdb37ad3edb3b238de416a4"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "640fcd0098ff924325a02a6ad6762e21104b257e51cd10b09fff0d58b73531e5"
    sha256 cellar: :any,                 arm64_sequoia: "01850d7c04be3f6c6cc44d117f1c318123ef0647e0b1e07291bc6fcc8b8889cd"
    sha256 cellar: :any,                 arm64_sonoma:  "0a77fb06c819f02c92e541d4ca69d02bb06c658b0c9a04b070a54e33a81e6b1c"
    sha256 cellar: :any,                 sonoma:        "191d6c302294a563e1157f2c060d19021c0f5702d1bfa21bed6894f840476c2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a74d1d8b661ee6267b88726ef57d15b32a013d13a525019d1144e4d1a002736e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6f70d8422ce83a45565181019dc2751a66fcf9eaebf26aa8b055e1db0eb7055"
  end

  keg_only :versioned_formula

  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c4/8d/af94a3a0a5dc3ff255fdbd9a4bdf8e41beb33ea61ebab92e3d8e017f9ee4/botocore-1.41.0.tar.gz"
    sha256 "555afbf86a644bfa4ebd7bd98d717b53b792e6bbb2c49f2b308fb06964cf1655"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
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
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
