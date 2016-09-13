class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/yyuu/pyenv-virtualenv"
  url "https://github.com/yyuu/pyenv-virtualenv/archive/v1.0.0.tar.gz"
  sha256 "3523129c24ca3ad2cf130885ef9801cb066b04eabc354ee2c38c486b8b726f15"
  version_scheme 1
  head "https://github.com/yyuu/pyenv-virtualenv.git"

  bottle :unneeded

  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  def caveats; <<-EOS.undent
    To enable auto-activation add to your profile:
      if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
    EOS
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv virtualenvs")
  end
end
