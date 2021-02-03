class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.1.23.tar.gz"
  sha256 "b5d7f0a723bc700868c8073541604584c9e2a6e91bf0d0d315fc27d292383d25"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bc927dd0c6d2e5ce8c974388510cf9dad4e046a0bd916a5bc449082269c4746e"
    sha256               big_sur:       "fa17d40ae3848e96502c2b99e102e1280da9be24bdf35d1d29d67c3e2eec6d33"
    sha256               catalina:      "410ca7719c612e8bb08eafd0240a0dcd78a7067bd4c12a7da9744bf33204e3ac"
    sha256               mojave:        "953d119d2c50fb49838a6853407af803267af90deea921a8bbe395d44c448997"
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
