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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef5a92549930c491d9c1c4239ae8db32562deff68ddb2b45186de2c07cc5211c"
    sha256 cellar: :any_skip_relocation, big_sur:       "b4f5d80260e3bb3c68cb046301a43a8bab7dc441cb37b91ba99ca8e3ab517d09"
    sha256 cellar: :any_skip_relocation, catalina:      "6fc7616201634dd898b64f9d4eea29c409a158ef8cc263a79b6f1f248f80c4a9"
    sha256 cellar: :any_skip_relocation, mojave:        "13e55b110d2894d925bbd2d232b000b82ace082e12c75b105d8e2d5c4e2946f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee5a894ebadc0b51c55004631f38d96742c4d1ad3dc910fe99f61727035bd03b"
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
