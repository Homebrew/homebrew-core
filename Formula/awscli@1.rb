class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.19.80.tar.gz"
  sha256 "3ffaafa08de6547ae7e4f40f84d4410dcc21fd4daf44541bb1250df4fbd323b7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7f019e3ce2e336f6b4214502e4c64cc2301a28cd18a5df5dc247158a64d19688"
    sha256 cellar: :any_skip_relocation, big_sur:       "b748925f937a3973e0d8b3907dec5c91df998ea5a1bc6d1d295c5d85d525546c"
    sha256 cellar: :any_skip_relocation, catalina:      "69a2942ce4e5c0a98f73171b55517bf41982d0e1831027f6d5347379f5aad822"
    sha256 cellar: :any_skip_relocation, mojave:        "d70a0b91cdf98236bbb70699a46eaabd1413a032b9ae1f3cbef1bcdd2c64ddcd"
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
