class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.14.40.tar.gz"
  sha256 "5c8818590419bcc531d2b39a28db64aea8f03b9427f477279e8a9f902ef56790"
  revision 1
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "74fe071540a2b15f63ec0e9640f3920a355c77bd9bd1574d6e9e13eae4be4e24" => :high_sierra
    sha256 "97c2d61d27da80c444b214f0a1b4ebf5c862c426ae81f8ead372b4c5f8608062" => :sierra
    sha256 "95a57c3ef5b5ad64d4f78168bb0b3896ff289627598b428837af5419a9bc1f63" => :el_capitan
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python"

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

  def caveats; <<~EOS
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
