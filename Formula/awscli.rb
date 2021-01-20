class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.1.20.tar.gz"
  sha256 "4ea65cbdb9d42324a765559bee42e72ad773f6331c665099b3fb785ff9c2b375"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 "1cfa546d744597c20d41389bf2f550e6acb6b437b7c6761275e7e5060edb4fa4" => :big_sur
    sha256 "6771482e2e8b217e7001c2175ec09552bfc4b22234d1511538e3238c503890ce" => :arm64_big_sur
    sha256 "b0b1c69daafa6bad6f8353061337083f0d8c03f2b1c1d753a7212d650459629b" => :catalina
    sha256 "36d46131c05224d2f8dfd9ed5c1e2af6194aa9dbe8c53d14d3f6fb5dc260c451" => :mojave
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
