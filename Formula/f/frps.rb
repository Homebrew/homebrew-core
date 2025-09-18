class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "c755c0aaeec3999cb259a312f3327db205a834abf0beeb6410dcdc818d9719a4"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98039929a1c42f35be721f8e0016cb913fb5627f55ccfe7ab78543c623c79054"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f6f5f99a0855ab3f6773b61435f842ed3c99173ab48ed0f2af510ceb202444b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f6f5f99a0855ab3f6773b61435f842ed3c99173ab48ed0f2af510ceb202444b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f6f5f99a0855ab3f6773b61435f842ed3c99173ab48ed0f2af510ceb202444b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3915be6e30d10f4ab16564e60ffe9efbd969295d3b311bcaa99055e30345d636"
    sha256 cellar: :any_skip_relocation, ventura:       "3915be6e30d10f4ab16564e60ffe9efbd969295d3b311bcaa99055e30345d636"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b417f18e672dfc619e85665c9b0005adb6a8edbef86fa4dbf2e61ece2801cdfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7834c7b4ec47f833f7ac20b4b603b323c302e1c8413d9b26661e431f1f68697"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags=frps", "./cmd/frps"

    (etc/"frp").install "conf/frps.toml"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.toml"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end
