class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.0.46.tar.gz"
  sha256 "adfbfe0f8238ee0e8e613671cdb1e188cd26395b8c65fe81a21fac43e71282ad"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 "057e8480b9575f3304e55d1d50f9710a589318a9324ec2eb1ed6634aa79d4b26" => :catalina
    sha256 "cedfd29a39e93178b00302d8f745f951742a0468c7a6ea75e42937325ffc2613" => :mojave
    sha256 "d2a3bbb47ca287d6529a25aaed6646c0b2220240a0d89702c9dfc4a97a2dbe40" => :high_sierra
  end

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
