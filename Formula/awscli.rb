class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.1.1.tar.gz"
  sha256 "650bc1dd125dbb040917d5285f380abe8966369a7c6dd7f0cfc76e7cc18814b2"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 "c421b3c811189cb1133e2880fd07336ef7c1871c8376b8fe4b2127f2d05fc386" => :big_sur
    sha256 "fcd558b100a42b5401932845ce7588b6f70be411a34684a243355bf5dae8dcc8" => :catalina
    sha256 "4e6ae917c968791d0f8cc4dfce4c4d7ae1782121929497120302638ae2638e11" => :mojave
    sha256 "bdfa90c8a378d555a18fd56a35feb8a9458bc7826f51140ad3ddb5d834054773" => :high_sierra
  end

  # NOTE: Do not upgrade Python to 3.9+ until awscli officially supports it.
  # See https://github.com/Homebrew/homebrew-core/issues/63990
  # and https://github.com/aws/aws-cli/issues/5692.
  depends_on "python@3.8"

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
    assert_include Dir["#{libexec}/lib/python3.8/site-packages/awscli/data/*"],
                   "#{libexec}/lib/python3.8/site-packages/awscli/data/ac.index"
  end
end
