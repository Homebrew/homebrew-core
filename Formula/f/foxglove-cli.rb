class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://github.com/foxglove/foxglove-cli/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "2c6295a593ba1714e9e75ba3c48820fb526e951ce63d64ec4d0de0ce6f45122f"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "daa9744a7b505ae4a0fe303b72a7aea9e36b578e2bb0b77a7ce64dcd96c63226"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b13379f71ac6329c84401208061143dcf2531ea1e67786760e02ae30ea137f2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd6897436fd20037dface40fd0a3e160ff3247d1f6e1dd162130c073447e871e"
    sha256 cellar: :any,                 arm64_linux:       "2abff9a56e361a7fb8c161f3c07217071ffa8b27fc725224ea5df1f2200393a9"
    sha256 cellar: :any,                 x86_64_linux:      "ab5587cf40a6b76e99fac0d0b4dca422e3b46d9bd32b44623fa89af78905dbd8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    ENV["FOXGLOVE_VERSION"] = version.to_s
    cd "rust" do
      system "cargo", "install", *std_cargo_args
    end
    mv bin/"foxglove-rust", bin/"foxglove"
  end

  test do
    assert_match "Not signed in", shell_output("#{bin}/foxglove auth info 2>&1", 1)
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    assert_match "bearer_token: foobar", (testpath/".foxgloverc").read
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end
