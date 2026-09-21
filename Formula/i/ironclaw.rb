class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://www.ironclaw.com"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v1.4.0.tar.gz"
  sha256 "6d9152c10d06e15b1178375ca6bed3a872e59b3e6370a0af74afe19b330b79c6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^ironclaw-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "951d1fa3501fa37bc0a657fd10371461dac5187eb619432d67e85b01549cccb6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "893f45d1cc3be920f7a22a6a271eeff2b33f483a4896df8e9ec3954261292d5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "073aadb441de78b77766cae83b80b69874bdcb8e9eac849cc4ba638f1cb5b006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "592f1115a92114004d1a9776b139dc6ed05a5dae33e50ffe2ac384c8a49be3d6"
    sha256 cellar: :any,                 arm64_linux:       "50b759e3ef51c910cb4cdeb95a9fa16219fcd4278494699df04f7eee6ada8d82"
    sha256 cellar: :any,                 x86_64_linux:      "ff7b5450b6457f6485f9416a803d930ae3cd7c6fa6457d445cd766dc9e6736ed"
  end

  depends_on "corepack" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "cargo", "install", *std_cargo_args(path: "crates/app/ironclaw_cli")
  end

  service do
    run [opt_bin/"ironclaw", "serve"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")

    ENV["IRONCLAW_REBORN_HOME"] = testpath/"home"
    assert_match "IronClaw Reborn config", shell_output("#{bin}/ironclaw config list")
  end
end
