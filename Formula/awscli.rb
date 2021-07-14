class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.2.19.tar.gz"
  sha256 "4bdc6a7cd18d45054d231e5e002d160589f108d7e3b67828dedfd292ce151747"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4e8434cebabf5b9ff1bdf58b5d4aa7b0aee6ab3be407bb29f2da1dc97a4bb188"
    sha256                               big_sur:       "eb20fb48e7d3c28cca3d511df8b5d606facc5c88392913e7cdc64bf7bb4df5e0"
    sha256                               catalina:      "56bc5fd89ab1ddf5993ba92390d84e7ae82b799cddbbeee02d0e08a5ab6ddf66"
    sha256                               mojave:        "75ef7222cc57dbd1ea152bf1613d27c6c8ddce348f3dd30c0086a7bd05fb8b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85b44f887fb884d1eb154a56a3ab112f9c49354a02080fb799e0db6bac4dfab9"
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
