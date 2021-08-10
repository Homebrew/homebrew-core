class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.2.27.tar.gz"
  sha256 "71bd2c10c0629c4a82f76667b150c36caf8ae410a070a78d3da7c15036f5c639"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ac43c810405e80a7fa080fcfb8071f0f594470441972dd7cc858979263364dbd"
    sha256                               big_sur:       "e45b6091913bd0b81a5eae562b96433a616ca6eb7ae81b439fbf9de71405b211"
    sha256                               catalina:      "75a829df2be1a5e24f436524ad14d51b4a8abd86e803c8def8b054bfced6fbea"
    sha256                               mojave:        "7ba5a544cbace37c5ed57d58b5e1f23222db99bf6b77d5be5d8fee1696b646bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a9cad2b31c61d57489bc6b40359a1039f765fc414fd0bead5a24a9ae731fde6"
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
