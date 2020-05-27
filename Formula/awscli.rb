class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.0.17.tar.gz"
  sha256 "797f57f3851855754dd732f5c3bf2c0b20d4e5cf72293ec70578361c037133a6"
  head "https://github.com/aws/aws-cli.git", :branch => "v2"

  bottle do
    sha256 "1bb1b021de1832c0d82fc3b6190423d3ae8728eb1e84f13a26ffbfa644caae8e" => :catalina
    sha256 "60e40c85641d6e7d7d7d66a3ab41ff8ca35c13ff0ecfa77c9cc52a2946690672" => :mojave
    sha256 "12e48ac42f7c9fc7c8512368f1dc516a9ce89b1bbd1babd69c2a9c0f79891db9" => :high_sierra
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python@3.8"

  uses_from_macos "groff"

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
