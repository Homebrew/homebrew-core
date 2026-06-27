class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://www.ironclaw.com"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v0.29.1.tar.gz"
  sha256 "6ba95fd3b4718648b5be271056baa2e48fa77de35dc491f22b2cb0445b6b5a42"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55e037d9c4e175b52fb93ce7456c2ecabaae040bc536d2032740d0044ca37135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02e4f4ff3cbb3172a2dc267256bb401ff1c95540ce8e469eadbc27ab8abbab4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeca00e67c5554d5f72e4cfa05eab42a462aa339cca8dd00c3639e85d934d81e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e62589ed8da4223d89f55a8c8a2697984bddb1c2c962bf08df37017031711f7"
    sha256 cellar: :any,                 arm64_linux:   "26bb099cb32186989f197949fab3f11e5700f61b0951cb03f3d302790fee108d"
    sha256 cellar: :any,                 x86_64_linux:  "fc4e030ef4ee2598088babf34f837813c38ff8e8ecae1e86d33fcbd28cad27b9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Missing required configuration: DATABASE_URL", shell_output("#{bin}/ironclaw config list 2>&1", 1)
  end
end
