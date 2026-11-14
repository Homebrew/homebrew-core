class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://github.com/jdx/packslip/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "d3fab179e103435f5c2802d259d317e3cb5214339f4c6d17f04a1c50277a5843"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a31e22da499b96237bc7cbed460642c8ee339a015fa03c2324a8e780debc755"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f4f13930fd266b4244b2b234d5a3809016e9c8a81b94b8d6711560a8cc64866d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe26a2b55f6fcb96c9f138409dd03f42f88bbd195cb3aa585278d582384028e9"
    sha256 cellar: :any,                 arm64_linux:       "d4bdde997d7bab5b29cd784aba31d81a9440fa900825ecc332d33b9726b31ac9"
    sha256 cellar: :any,                 x86_64_linux:      "1e7044050931795fd190300004827ffe46e7b4b587c1f9df6852e6a78fdcc6c2"
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
