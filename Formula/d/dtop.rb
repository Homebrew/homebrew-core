class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "39493f9c6a3f8f725bfb712d4c32df3461224275e1d07ec16eea37a3b6beb6b8"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "837b271a130f2d5db1bfbc25f844ee290640a8980f2a539921f4daea3af4b65e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1360bed2d5b5343ff472404debba9b8be085c1c2931f7e31ad73f129ae069d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1dea3b58640c554fef04c5b2e05a221e3e70074316d398b35fe5cd2995fc4909"
    sha256 cellar: :any,                 arm64_linux:       "4edb6cc7422f6c480dc84fb9d35b883b46326c2b343f8f582ac0026a63c6f85f"
    sha256 cellar: :any,                 x86_64_linux:      "019f267da0dbf1cdcc7da85a3320aff79d3f4f52c28f02ef316a53ec882a33a3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
