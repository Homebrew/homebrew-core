class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://github.com/pyenv/pyenv-virtualenv/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9e2a425d96447bb45235ba8630acd4906d018e5e93ea2bd0133aad3d8bda24ba"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2367b93a908ce216bc8d5c14216466eebde917271f97951ac13da21e08ca204f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2367b93a908ce216bc8d5c14216466eebde917271f97951ac13da21e08ca204f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2367b93a908ce216bc8d5c14216466eebde917271f97951ac13da21e08ca204f"
    sha256 cellar: :any_skip_relocation, sonoma:        "88ed48e401f7a08e8fa61a978f3ab6d72de09d4dfb2cdf2e94e6569075bad310"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "185778a56be8e883b66a26ac2f03c6fc7ac3059a50e1d2738e246efd5303c9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "185778a56be8e883b66a26ac2f03c6fc7ac3059a50e1d2738e246efd5303c9d0"
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
