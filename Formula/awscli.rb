class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/2.0.0.tar.gz"
  sha256 "c6064a4419432cfae0a7866a7ab08ab2b2a686c6452ddac1369a45a3cf003c7e"
  head "https://github.com/aws/aws-cli.git", :branch => "v2"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed66a81ad012426c49328d7d1ff6b49e871a9ff54e2dd22ad726c38f447d4fab" => :catalina
    sha256 "250ff17d41717dcce1cac123eb286030c0c2b3290c7272fa2ffbd1bb8fe1d02f" => :mojave
    sha256 "372c8e6b3a9b243ebddc2003730160ef9da3300ec029e2598b70d0f186365814" => :high_sierra
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python@3.8"

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

  def caveats; <<~EOS
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
  EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
