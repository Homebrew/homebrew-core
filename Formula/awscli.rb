class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.1.17.tar.gz"
  sha256 "67bf406208ea47cb6f3ed6b21533bde01cc5cfc35dce6b1214fabbff9dd5e662"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 "769aa8fc89f91485a0e1d7c1e83d78f97d69ca3c716f768e48f61cc804ff7093" => :big_sur
    sha256 "9fd0ae1987d0e296c3719820d1c29a980d0cc6bc61ca6d377d7f19e4380bafd0" => :arm64_big_sur
    sha256 "adb98df66ebdf27a3caff23ba9e313cb1818c9b81090796c36625ca27502e528" => :catalina
    sha256 "577eb7aad3ee1293562373af751d9dc87ed8c6cc3511eac21413246c60a2e0be" => :mojave
  end

  depends_on "python@3.9"

  uses_from_macos "groff"

  on_linux do
    depends_on "libyaml"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "-r", "requirements.txt",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    system libexec/"bin/pip", "uninstall", "-y", "pyinstaller"
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

    system libexec/"bin/python3", "scripts/gen-ac-index", "--include-builtin-index"
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
    assert_include Dir["#{libexec}/lib/python3.9/site-packages/awscli/data/*"],
                   "#{libexec}/lib/python3.9/site-packages/awscli/data/ac.index"
  end
end
