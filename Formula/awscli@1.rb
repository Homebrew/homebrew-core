class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.20.10.tar.gz"
  sha256 "25cc31a926f43761cf17689ca4558e2f73d956a02064cabc265c6dd10aeb15f9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e4990f86b46a557aa3bb0a2f93a2da3666bc5728c73a9fe6f90e89811d9e2c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "9183d2f5ddd15adb69b47a61e3ea48207892f39024d1e973bb8b9f3b33a0659d"
    sha256 cellar: :any_skip_relocation, catalina:      "9df59a669dae9acc4cc8a22534aa0b1b99df14d5878cd9183aa3b643fad26f36"
    sha256 cellar: :any_skip_relocation, mojave:        "4fe74c77019cd3ee34cf161f69048ab8805171e9d6236ecbf79482f12593fdf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70275b72c093ccbe1cb7a283e14c21940aefb3b2989e510f5dbc5a00354096c2"
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
