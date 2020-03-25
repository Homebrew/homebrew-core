class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.0.5.tar.gz"
  sha256 "d1727a8251da51426f71daae2d79a685ec5e53011b7103e37f63e54253744b4c"
  head "https://github.com/aws/aws-cli.git", :branch => "v2"

  bottle do
    sha256 "76223bb3530150558fad23ccf7147e4544c157c21c1c0b0d5b1e9e73711c6a83" => :catalina
    sha256 "91500dc3c3f742f0fcad7c80cb5bea0f55b39009a6c29e5dda6774b775257611" => :mojave
    sha256 "3170cd1fd724694f2def5818480ab7116e61181793a2b46dbe68679f4c515abc" => :high_sierra
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
