class Fw < Formula
  desc "Workspace productivity booster"
  homepage "https://github.com/brocode/fw"
  url "https://github.com/brocode/fw/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "b7212f782eefb24e481dd0c361525cbb3ee46ac0cbf2f27bbd6011b4ba49d572"
  license "WTFPL"

  # This repository also contains version tags for other tools (e.g., `v4.4.0`
  # is an `fblog` tag), so we can't reliably determine which tags are for `fw`.
  # Upstream only creates GitHub releases from `fw` tags, so we have to check
  # releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17217d03e13f9d6bb51bff058d4906abeefd0d88d41ebfd8a0b58de179b84f22"
    sha256 cellar: :any,                 arm64_sonoma:  "bed94da930d816240dc2afa69c16df737d90d48fc830075a3b945025312cf800"
    sha256 cellar: :any,                 arm64_ventura: "44e8ec3e5844f12c3ee137ab19a3e8062bff39957dc7e837a9665a04a54df54c"
    sha256 cellar: :any,                 sonoma:        "1dfb39b2365411508a694fa9832e315674fb00a19b8aead534c13ef20ea998a2"
    sha256 cellar: :any,                 ventura:       "7a1d6b4ad35e3a7631b67bc1c78637a8c8292ee904cdfbc7a45f04cd39e9b032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1cca454737de3f42364aa83b5bb61322c384620f3ae78556c1df38777599265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbf2ad75164a1529751022a7a25f8b7e0e1c543ff4227032cf73bcec07ab32e9"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  resource "fw.1" do
    url "https://github.com/brocode/fw/releases/download/v2.19.0/fw.1"
    sha256 "b19e2ccb837e4210d7ee8bb7a33b7c967a5734e52c6d050cc716490cac061470"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install resource("fw.1")
  end

  test do
    assert_match "Synchronizing everything", shell_output("#{bin}/fw sync 2>&1", 1)
    assert_match "fw #{version}", shell_output("#{bin}/fw --version")
  end
end
