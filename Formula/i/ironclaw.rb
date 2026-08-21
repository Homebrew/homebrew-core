class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://www.ironclaw.com"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/ironclaw-v1.3.0.tar.gz"
  sha256 "431154b5ee1ab9647faa422eb98827a1d3e92560ba16ecf2c9d756f5736d7688"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^ironclaw-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab62f29863706a41ea6e2b8f9f1d41c5541554cc5e928a335cd03b1ec2a5bd50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c4acc0493c8f6a38c3150fa89ceea51bd130ae7afb2a62d1d6df3e21856d851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b07eed876e8f8419f3d90c992571318b1ecf5b0e400cbc4788b5e9ca81ac72b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4824873ee2927679c13cafdcc10aef247844250229ecb419b943fb5520000842"
    sha256 cellar: :any,                 arm64_linux:   "2841842cace6e4c769f38366636d31ef3435029f6235057fbd62dd5111fbad49"
    sha256 cellar: :any,                 x86_64_linux:  "06b1f249514d1b656c4e64891bd2683a4daeabac5c465ae74a88e468aa421149"
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
