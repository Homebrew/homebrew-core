class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.2.18.tar.gz"
  sha256 "c2946375f01d5fa8abc119cce9df9a6456db458c53df60647fa3c6222b623965"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0cfd633cb90b28d36c5b0291864de2b4ea12c806d840f4a46b13e7f60e59d657"
    sha256                               big_sur:       "1cdbd794a59c4ce0cb0724808b1a0d4b6938c9bbca5e36b49fabc3c20957eb96"
    sha256                               catalina:      "79173c4c1567e57014118db6510db89c1773a64dcf32d288d52cce8d1e477bd0"
    sha256                               mojave:        "09f57750b94d3b7470127a8c43cd1f22cd14305b60c395a3163e31754274820c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d43d101a493b1a89a0a3be53bcb7bbd812c86880d87acdbc7635f1a51cc2500"
  end

  depends_on "cmake" => :build
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
    assert_includes Dir["#{libexec}/lib/python3.9/site-packages/awscli/data/*"],
                    "#{libexec}/lib/python3.9/site-packages/awscli/data/ac.index"
  end
end
