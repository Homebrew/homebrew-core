class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v0.24.0.tar.gz"
  sha256 "b920af1ab1d2c4753cd275b0813b958df7db650de2c951339a649f733e9a132b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0db4bfe30f97b5662657fc3baf2d03aeb6298878593cce2fdc835773adc7c3b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb1b104cd96ca30fe876b25ce4959a109a8a66bb4400b5ba39d28b6c80a51c2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe7b136a6fc290a5b20fa13a2aa6a68d700908e1fecd33f5c8abb4533077e230"
    sha256 cellar: :any_skip_relocation, sonoma:        "57fb49d1bf117d3a843b93914dea4512f0552c0c85821b5f6289bfae513130d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "171b7b979787477ff7a312b4250118dcf08ae3ee5cb0d8c17ca36c0dafe87a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c32c2176a5113c3e2fbff7bb9c91ecf7f2f9a19c4bf6c19e7fb6266b9584451"
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
