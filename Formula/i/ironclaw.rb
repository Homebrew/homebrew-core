class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://www.ironclaw.com"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v1.4.1.tar.gz"
  sha256 "1fb826d6ce730a659205f6e60093bb9a79eb02bfd2535b64c9b19bec13ede034"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^ironclaw-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d0c4087839bef72dbac7d1465303f79d0def698ad5cb8efb87c949b3b887d25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be6484012551ffe7f78017cb85e134db78e4467c41eac3be95dbafd696c0a643"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6b709f291d54eb0231662e3681e2bc4c3561faafeee6627b0b588710aeeabd1"
    sha256 cellar: :any,                 arm64_linux:       "31df5ee642866ad94b99d59e0608bbc470c74b8aa22e79f1d34cf83d69e1f4a5"
    sha256 cellar: :any,                 x86_64_linux:      "6f99580a43764b09798878ae3b2b2fd69d9cbf8f8eddb5fd0d2e2caca0a424b3"
  end

  depends_on "corepack" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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
