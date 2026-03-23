class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "a36b11cd19c2fe99011078c5680052f1778758d31d4b7dcb6cc4e019c1575325"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a48a279716887ba5f3985c03c37c6b12598aa4f2fbc918faa6206961fab6586b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23920c242148d9bdf1abcaf7d09a33cb83d323eab6efe3806055abc7a5690044"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bc6defb30593b19548dc3b24e6a1e8c869393136dd9ca04982b08c38695a56b"
    sha256 cellar: :any_skip_relocation, sonoma:        "867793377d4187f2430a3703b1d219fc1fe3ca8bb4ed6bdaa80a0b11305fdd99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a055f41f5bb7a79755b19c137f3dfb63ff87943f5e2db6594f42a39f53f7bf1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3ea4efe4a28bd19024739d8c312a47436e3b6f02d6fa61c70781501ab4a27b8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end
