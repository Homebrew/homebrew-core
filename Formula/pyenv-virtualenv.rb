class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://github.com/pyenv/pyenv-virtualenv/archive/v1.1.5.tar.gz"
  sha256 "27ae3de027a6f6dccdca4085225512e559c6b94b31625bd2b357a18890a1e618"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git"

  bottle :unneeded

  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"

    # These inreplace steps may be unnecessary in the future if upstream
    # addresses the following issue and PR:
    # https://github.com/pyenv/pyenv-virtualenv/issues/307
    # https://github.com/pyenv/pyenv-virtualenv/pull/308
    inreplace bin/"pyenv-virtualenv-prefix" do |s|
      s.gsub!('"${BASH_SOURCE%/*}"/../libexec', libexec.to_s)
    end

    inreplace bin/"pyenv-virtualenvs" do |s|
      s.gsub!('"${BASH_SOURCE%/*}"/../libexec', libexec.to_s)
    end

    inreplace libexec/"pyenv-virtualenv-realpath" do |s|
      s.gsub!('"${BASH_SOURCE%/*}"/../libexec', libexec.to_s)
    end
  end

  def caveats
    <<~EOS
      To enable auto-activation add to your profile:
        if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
    EOS
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv virtualenvs")
  end
end
