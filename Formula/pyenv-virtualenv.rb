class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/yyuu/pyenv-virtualenv"
  url "https://github.com/yyuu/pyenv-virtualenv/archive/v1.1.0.tar.gz"
  sha256 "26c71a30cc876350c48d670a128bd49be662ffad87b00ac91f907afea3a21f9f"
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
