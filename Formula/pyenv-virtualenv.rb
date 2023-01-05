class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://github.com/pyenv/pyenv-virtualenv/archive/v1.2.0.tar.gz"
  sha256 "1824a1a6d273f6efb38a278b60070bd412cfe6592440b73fcf0e0f2d22730aeb"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e3bfba31c3d4bc538ff156e225ca3dbb1fd15e27cd8fd5885706eb0efdb4405"
  end

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
