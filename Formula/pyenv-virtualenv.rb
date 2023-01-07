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

  on_macos do
    # `readlink` on macOS Big Sur and earlier doesn't support the `-f` option
    depends_on "coreutils"
  end

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"

    # macOS Big Sur and earlier do not support `readlink -f`
    inreplace bin/"pyenv-virtualenv-prefix", "readlink", "#{Formula["coreutils"].opt_bin}/greadlink" if OS.mac?
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
