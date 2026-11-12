class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://github.com/jdx/packslip/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "d3fab179e103435f5c2802d259d317e3cb5214339f4c6d17f04a1c50277a5843"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b52c7280413818aeb9ab97b235d8b5635b02bc6830003aa05d887ac2bc5aec7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36b02bdd3ddfaecb89dfe0e3c101696647a0d7b6d1121c7bc39a388114654390"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b4703f2b9b46ba2b4c9283902cb0c7e5ac20120d78654b75e57104e583379866"
    sha256 cellar: :any,                 arm64_linux:       "647bf46db368a979ddf4be51f2c10b69048f7abcb511865dc6837ed4b654aa25"
    sha256 cellar: :any,                 x86_64_linux:      "e85a4b9ff0a13e79ba188437f587511737495c055b465a0f053e4bfdd5462a43"
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
