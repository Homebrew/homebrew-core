class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://github.com/pyenv/pyenv-virtualenv/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "4094a7b43552481eccc8fe23661a9cf06eb2de86d403625fd536078a691b10da"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70ad6bd810b1c59dd95e8dc6d87a5135d184f9a48c8e8b67803e8d54abf03780"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70ad6bd810b1c59dd95e8dc6d87a5135d184f9a48c8e8b67803e8d54abf03780"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70ad6bd810b1c59dd95e8dc6d87a5135d184f9a48c8e8b67803e8d54abf03780"
    sha256 cellar: :any_skip_relocation, sonoma:        "06fadc8df2e7de479b5da129213c5919a4233776e2128d84bd01341fe5692f1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11936498dd69400cbbb0b9fdecaaffeed1d1a0d648a974514f3de990a983ad60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11936498dd69400cbbb0b9fdecaaffeed1d1a0d648a974514f3de990a983ad60"
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
