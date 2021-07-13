class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.19.110.tar.gz"
  sha256 "c2674f4323a239bd44544f5b413ef79430f5dca5071a8843ff80e2ac754c9e07"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aaa64cbcc2700b8925ff96eec1190e3fa5cbb4d9b99b80f6f2a92b04a7f1ab74"
    sha256 cellar: :any_skip_relocation, big_sur:       "42ac73057de7687a31cf220b18c8eabac4cb7d431b3b247f3e54486bdc8b134d"
    sha256 cellar: :any_skip_relocation, catalina:      "e5ea21ff85261f415a52029640cf90693ab1df11043b90af9e145d3dbe85f471"
    sha256 cellar: :any_skip_relocation, mojave:        "999a9d989515774d691f965a932adc0340141b5187cebf60f499f172d0039b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "387a64947cbbb8cb5add7c1d9476ea63e317e97b449f2d6531df724db12dc795"
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
