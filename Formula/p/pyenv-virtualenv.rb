class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/pyenv/pyenv-virtualenv"
  url "https://github.com/pyenv/pyenv-virtualenv/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "cbe485abbf05c3d2e8b3c6ae0babca361e173dcd73f76c8cffdc11b0273c7d83"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv-virtualenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f96328782e3a77ab7793580d119644e11c329106620d4c14a6ed81cba589285"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f96328782e3a77ab7793580d119644e11c329106620d4c14a6ed81cba589285"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f96328782e3a77ab7793580d119644e11c329106620d4c14a6ed81cba589285"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6976be94e436a8922a51e4816a003f38bf40b230164c90b8ed2fac0d9e7ac764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6976be94e436a8922a51e4816a003f38bf40b230164c90b8ed2fac0d9e7ac764"
  end

  depends_on "pyenv"

  on_macos do
    # `readlink` on macOS Big Sur and earlier doesn't support the `-f` option
    depends_on "coreutils"
  end

  deny_network_access!

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"

    # macOS Big Sur and earlier do not support `readlink -f`
    inreplace bin/"pyenv-virtualenv-prefix", "readlink", "#{formula_opt_bin("coreutils")}/greadlink" if OS.mac?
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv virtualenvs")
  end
end
