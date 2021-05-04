class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.19.60.tar.gz"
  sha256 "515051ca7739caa24d26e59669c67863d804e77d388ea1a1debb690fb0ea375e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1dde053f44ea33b71f4651286ffe0241aacce5495d5e67b4e46bb9b4e3b3ede7"
    sha256 cellar: :any_skip_relocation, big_sur:       "1af46d969423f9d2a119bd32c6db7bded3ea912ec8359a173fb73c303a6ec6ed"
    sha256 cellar: :any_skip_relocation, catalina:      "f4173a6f27541f7ec72b790ee403b83248b81e441fc8b166a1cf45c2a829e921"
    sha256 cellar: :any_skip_relocation, mojave:        "17452b335f0d86dc60aa90e077a01204b4295e616cd7194f258777ff7343413f"
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
