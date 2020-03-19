class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.0.4.tar.gz"
  sha256 "377c48c90228196704c229ea7111332f4dac131419722213bf55d4075ae94a0b"
  head "https://github.com/aws/aws-cli.git", :branch => "v2"

  bottle do
    sha256 "405a9159cf128dae174f7e5ce24f6824e6b656520a916787bf17e2f22ca7bf08" => :catalina
    sha256 "31293407962228bf88de5c3e7d387251af8e186a7b4fad5d9fb2f7f5f8f3a80a" => :mojave
    sha256 "b2f11b2d9871159ad7965dcb20438692027dd4951422860e5f891aa4f09c3bea" => :high_sierra
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python@3.8"

  uses_from_macos "groff"
  uses_from_macos "libyaml"

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
