class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.16.220.tar.gz"
  sha256 "4ea217935d07972d7d2adb4cbff49b16b0788e01ce9c52eac34877e82c996310"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "36dd39fb4b35d265ae7891cd746eb36a0c43e681d10ab4340e93db958691585a" => :mojave
    sha256 "8e583161a5680d083b14fdd6be17256651a3001613f6eb98fa2089242e0ed25c" => :high_sierra
    sha256 "699fe582bfe50a55a5f5513e75dd8b10b08302ed0439a03e95e5c5dc6d5746a2" => :sierra
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
