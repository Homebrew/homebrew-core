class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.18.150.tar.gz"
  sha256 "1c916fd6b70231e96be3e2f9d4386b70ba414577a7905399c3ee430c91a27f6c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "85a98d4a8ec16107cc2459b95827bf397f568e8fd7ea203c8b18d72fd4aade7a" => :catalina
    sha256 "279c60b2399bf67f4f2b091d80c9625cc233fc08e20df59273ca5767cc0b0f45" => :mojave
    sha256 "8441193b4e13f6ae76d14815fdf6c6504fa3365eaaa74dd4dab1a19fcb0ecf01" => :high_sierra
  end

  keg_only :versioned_formula

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python@3.8"

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
