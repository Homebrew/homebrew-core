class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/1.5.0.tar.gz"
  sha256 "1ae87be745cd2b505ee3c0fa78e204708e188f82b0c53cd3899ff398a00eef9a"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8869a328fdcd6dfe7218f3fa0f8aa4e4fd92f90b2484a5e38ce99bd32b64e3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8869a328fdcd6dfe7218f3fa0f8aa4e4fd92f90b2484a5e38ce99bd32b64e3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8869a328fdcd6dfe7218f3fa0f8aa4e4fd92f90b2484a5e38ce99bd32b64e3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a1c271ff176331ae8fce68e613653b58e982bd61a61c3fb6351c917146a06528"
    sha256 cellar: :any,                 x86_64_linux:      "0b6ff6fdbc9f8d243aed2d8d4e6b1c2ac3fbf833db94690ca8edaffe0d8a3866"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")

    # Linux CI container on GitHub actions exposes Docker socket but lacks permissions to read
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "/var/run/docker.sock: connect: permission denied"
    else
      "Is the docker daemon running?"
    end

    assert_match expected, shell_output("#{bin}/pumba rm test-container 2>&1", 1)
  end
end
