class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.115.tar.gz"
  sha256 "a50016f5e688c28e719f2d6dc4e9f1066d3be39e71255215dbaa05d3e7a3ce08"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "08ebf55db4ebdb6e9f4ec59dd9ce8c2426ff4024ab76c8f71f7826066fd1e887" => :sierra
    sha256 "ba2fd6ce78ae8dc96409a427943e71498dea2edbc9e770be08d4bbcdd01a9d05" => :el_capitan
    sha256 "6533f974f8cb12da38db091abc7e73a6293b5ce009a2d9fa8e673658b4ab0f32" => :yosemite
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh" => "_aws"
  end

  def caveats; <<-EOS.undent
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
