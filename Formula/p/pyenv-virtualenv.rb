class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://github.com/pyenv/pyenv-virtualenv/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "6f49a395a17221f87e1e16f0f92c99c3d21d4fc27072d5c80e65ca11b686eedd"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4471ee71c65c00eb696e6caeda86d7cd9fa128c17657ab040592cf5a89502b75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dbb7fd295ec2ea03460bcb5b367be4ec2772fc2d2ecf64765309fd39e10e18a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5520ee72fd178ae11886721c276fcfe4008434519d8d56b25ff9eee7d40f5a9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5520ee72fd178ae11886721c276fcfe4008434519d8d56b25ff9eee7d40f5a9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5520ee72fd178ae11886721c276fcfe4008434519d8d56b25ff9eee7d40f5a9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5974b4594ca7e79058e457bbe88147751611efc836ab587cf9ba65732a3ecde5"
    sha256 cellar: :any_skip_relocation, ventura:        "5974b4594ca7e79058e457bbe88147751611efc836ab587cf9ba65732a3ecde5"
    sha256 cellar: :any_skip_relocation, monterey:       "5974b4594ca7e79058e457bbe88147751611efc836ab587cf9ba65732a3ecde5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "56ce37582f357b6e5bdd841b9d9a780e2a1b3ed473f20eef778105cfec203176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "248fd1598c1d3a342b6b0c23491b4b7b8700faf3c985635409f5f3fdd09932fd"
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
