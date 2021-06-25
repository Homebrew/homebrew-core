class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.19.100.tar.gz"
  sha256 "e8e46f1573b9a668c7b0329bacc3530b7c70764e7896ec898b62d23bf5a3ee2f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72c45fc7e2f69c1c3cc7981df7957bd0dc9e8b1bfd0cf38d1c6128ce181254d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "12ee40b046c8f257eba6759e40ff7b7eda0848f97d1ec35280c53243c1313b83"
    sha256 cellar: :any_skip_relocation, catalina:      "d432d1e2e07f21a4fbf6fc5b6ae4e8b4abffb93bd99abb75472b12bfb9137644"
    sha256 cellar: :any_skip_relocation, mojave:        "76422b9dc324e6c6bb6915c4adc415dea9cdff0ff98f459c37fd0e180742d5e2"
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
