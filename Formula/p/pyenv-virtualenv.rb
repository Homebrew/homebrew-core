class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://github.com/pyenv/pyenv-virtualenv/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "22f0248e9d6bf6a7c459ba5f790a625fdcc25afaffd9213369d8b29fc8a5b656"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e4afc272034aa96f61df27d68296542cd21a92f8abdf7c2126684fb78fe93e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e4afc272034aa96f61df27d68296542cd21a92f8abdf7c2126684fb78fe93e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e4afc272034aa96f61df27d68296542cd21a92f8abdf7c2126684fb78fe93e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "13be379aec1f27cc830124968183b08dd1243615aa9a53add252919712f15851"
    sha256 cellar: :any_skip_relocation, ventura:        "13be379aec1f27cc830124968183b08dd1243615aa9a53add252919712f15851"
    sha256 cellar: :any_skip_relocation, monterey:       "13be379aec1f27cc830124968183b08dd1243615aa9a53add252919712f15851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6513b107bac78b4952fa7f72d0278360106843c4a854e091af0f045c487788b"
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
