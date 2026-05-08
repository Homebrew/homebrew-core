class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://github.com/pyenv/pyenv-virtualenv/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "9aaf9f01660f10f538251fdaaf552d429e7fd41efb7b651b69a3a9768f4a181f"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db1cbb985d132f266721fa18646934134da8937207cae9d6556820549eb99abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db1cbb985d132f266721fa18646934134da8937207cae9d6556820549eb99abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db1cbb985d132f266721fa18646934134da8937207cae9d6556820549eb99abb"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dfd9c5b2043b4de679a5451881fb073eb11026aed8bbc9c5bafde5f618b0c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab5d01834a7fa0ab1f874a9e9df33d907422b56204ae73da505a159288412f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab5d01834a7fa0ab1f874a9e9df33d907422b56204ae73da505a159288412f21"
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

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv virtualenvs")
  end
end
