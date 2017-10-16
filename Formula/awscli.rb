class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.171.tar.gz"
  sha256 "06ae8bbfb236aabb147102f4735d8ac59b6267559af4f3cab94b0e6e608d5d4d"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "084a5d68f86f6974e589daa3fdf47a583b36187e11b1e8f0779c024e7460f6d4" => :high_sierra
    sha256 "2c09014e6b80900fa024becbfae6088b54778070a378bda8787ae6bdd1240dce" => :sierra
    sha256 "b379996f7a48750378924b7613f5efc9194f7efb42639b53de333d6460c9ea30" => :el_capitan
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

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<-EOS.undent
        #compdef aws
        _aws () {
          local e
          e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
          if [[ -f $e ]]; then source $e; fi
        }
    EOS
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
