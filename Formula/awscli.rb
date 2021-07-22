class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.2.22.tar.gz"
  sha256 "867d7d45daaef9e3e8f52771fe21b306dc25d545c0f46d57b34806134efd7c64"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "025500318aa04af00d79c23da3d71fed3565ad40b6f07b0669cdd5655b73c73b"
    sha256                               big_sur:       "9f5b5037d5eed44c7d86cf8b6d7c27cb47eb8350de18654da98e88749dcd2e4b"
    sha256                               catalina:      "955204f33ad8e9207f96fd45bf5351174a4bc341df93d6e426a7b1651f34191a"
    sha256                               mojave:        "4249963c3145597a0d34bb2c635b1eb393ca7d21bba6c68c292abd50a53814c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0517b17c74804a786b63d8b40bab0703167aa0052aad9858d6eafb7035f66d2a"
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
