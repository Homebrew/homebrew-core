class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "658c834a8f2ed307b87e7605b8ae40f5c3c351fc10cb3aa052c8ee1bea03b42d"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed6c5283c848865353bf78c371a8ad3977f6174337a450e6cc80249e504aae29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04bddbeff78042b4813b4aa6cd7edaa21bd68f288e31be4f9d01fde6cc906498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d6fdca18e9c27a25d6b92ebe1f1a73990f005d7a5c285bf83cd715ce71dd368"
    sha256 cellar: :any_skip_relocation, sonoma:        "f164703389d5a0ec0a7fdc6ff4d5f1b6adb8637da0740d630aa6e5633c801ff9"
    sha256 cellar: :any,                 arm64_linux:   "5635764d600b0fcec0ba75d4d174b6fea0ca979c6904aea892d30af83513b6d9"
    sha256 cellar: :any,                 x86_64_linux:  "730b9c5ad2bf511e2632253976f37d2405cc79ded14a1c22d3df7b53de14f4b5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
    assert_match "ok", output.downcase
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
