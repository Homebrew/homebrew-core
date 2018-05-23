class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://github.com/pyenv/pyenv-virtualenv/archive/v1.1.2.tar.gz"
  sha256 "0b50a344e427b64be8218395281eb076d526b1cdc767f793f0f3d8438b198117"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git"

  bottle :unneeded

  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  def caveats; <<~EOS
    To enable auto-activation add to your profile:
      if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
    EOS
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv virtualenvs")
  end
end
