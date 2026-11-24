class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://github.com/jdx/packslip/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "30a7f3a55badc50a48e53632cd6d07fe3225d080668833dd20e4b593c5f5a845"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    manifest_sha256 "b3df959418b8284fb81a9f2def5a09e43cff20416916de0da76767bad3c0f05c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2642624ed22a5c21e97c2c39c86f163dc0f875503198101f043dfb38eaba01a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7456b86c9246412e6d022a731ec1e485cf6684379d03ddbbe6664050c7faecc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a59f6f2a6ef0c4bcf124919cebac6cc3b35e9f44e03e88869450295d46ac6548"
    sha256 cellar: :any,                 arm64_linux:       "7522401cb5e5a7b195e971ddbb546e1cbe64d6e1cce8c954ddb04969788ceb44"
    sha256 cellar: :any,                 x86_64_linux:      "a86d2b0db2c95c4652dfafd7f3704134cbf359dfff2b19e2927442d9ba64b40a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"packslip", "completion")
    man1.install "packslip.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/packslip --version")

    system bin/"packslip", "keygen", "--out", "brew.key"
    (testpath/"brewtest").write "brewed"
    system "tar", "-czf", "brewtest-1.0.0-linux-x64.tar.gz", "brewtest"
    system bin/"packslip", "create", "--project", "example.com/brewtest", "--version", "1.0.0",
           "--key", "brew.key", "--no-log", "--url-base", "https://example.com/1.0.0",
           "--bin", "brewtest", "--out", "dist", "brewtest-1.0.0-linux-x64.tar.gz"

    output = shell_output("#{bin}/packslip verify --pubkey brew.pub --allow-unlogged " \
                          "--artifact brewtest-1.0.0-linux-x64.tar.gz dist/packslip.sigstore.json")
    assert_match "ok: example.com/brewtest 1.0.0", output
  end
end
