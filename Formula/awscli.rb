class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.0.28.tar.gz"
  sha256 "8433691f1f877f6e3ca5f9ebc0aee494243d0d4c9cafa29c8aec5eaceb551245"
  head "https://github.com/aws/aws-cli.git", :branch => "v2"

  bottle do
    sha256 "e78c56cc551a3f5e252aaa51b79b27a08eeb0f23fdbb541f2cff2f44cc5cc0da" => :catalina
    sha256 "da6bfc03f073d766d0aa7ea4b488e1ea5be5fb10b7cf6180d99a2fcfc06174ec" => :mojave
    sha256 "6d865fb7ef17e1ca4eb5759ac5c647fca9a6cacb238b042c0af893db4e32a2e8" => :high_sierra
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python@3.8"

  uses_from_macos "groff"

  on_linux do
    depends_on "libyaml"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "-r", "requirements.txt",
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
