class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.20.0.tar.gz"
  sha256 "3f97e102267e502d087d5dbd7b8d5c4c8d87c3a0cb750f5e28ae755bb655b62b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "132efee0aaaeaf48fb086dc266176c28a2d34b433945e5f98c5ec94a2dbb40f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "7013c26ea7616b3ca8654cfc1b1060bb1f361cadb9812c122ebd5b9e54d9555c"
    sha256 cellar: :any_skip_relocation, catalina:      "731f250e6a090bb5423f09395163135872abea6341b06246ab7a7c203ec36517"
    sha256 cellar: :any_skip_relocation, mojave:        "84832cdede967853af4c590a82b29bd9c419b23ce3e48e1f88db5b6dfe7c76ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d46e30a175df04087e5e2cdfe354b1dc441e66e0f998b98da3fbaac06a8589c"
  end

  keg_only :versioned_formula

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python@3.9"

  uses_from_macos "groff"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
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
