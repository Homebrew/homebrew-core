class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.16.60.tar.gz"
  sha256 "989cad10b25f8dfb4bdd5f5ea8aef001161858253d11a9907697ce500674192d"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "e19331c7f8808a816870392491fef9511b1110f074cfe5bfe0376695d23e4887" => :mojave
    sha256 "390d03dcd95d482c55daa04ad2901cd8822a53e8c2a03376197f10331e543c25" => :high_sierra
    sha256 "4f5ad985b4585bab2192f865e23ec094643c5d74c22dc8aca1f6a6b4590f52e9" => :sierra
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
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
  end

  def caveats; <<~EOS
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
  EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
