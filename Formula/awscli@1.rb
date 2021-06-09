class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.19.90.tar.gz"
  sha256 "041a0c58dc8065284d9400c2e1f4e68440df5e1628436deb7a935b455a9a4a05"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7a3da0e61d45dd2e5cf1923b1cc50f76273e72793f0314055eb5e3a21ea4bd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "537925f61c9d268ad43558567b838d3086168e3b48d4622732749b9739df502b"
    sha256 cellar: :any_skip_relocation, catalina:      "5a0dccc3beb5b7bc50bd4dbae0391f6b66681e2121e76ef62fe9d0938771bcf0"
    sha256 cellar: :any_skip_relocation, mojave:        "41b7ce527cf7f465ba0074bcd22000a3d1fcd3550beef012f7a981e579848672"
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
