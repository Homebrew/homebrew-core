class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://github.com/jdx/packslip/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "9614dfacd1ce38b16e77bc4b8e05edc3c1aab19b602f9225dac3d55d13b45a23"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f70de02a2c68b131cf91108312377f21e1cb7473c1911c6e37ece965e507298"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4095fad80e7705fa7e993ccec8ee54a9ee3e735169fa8cb7946f3137ea7ea260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d25fd0399ed1f7ad8a1f851d993ddaaf11c2a71db2bf7bc31cfe502de5477229"
    sha256 cellar: :any,                 arm64_linux:       "55ff603c513ab1d64067cda2225b35ccd99d0da7b392603fcb4828dcdf208c09"
    sha256 cellar: :any,                 x86_64_linux:      "3b0c4ce7c46f2bfe066a29516b9a9057d5929592f8662cf69aea5adbb94d5869"
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
