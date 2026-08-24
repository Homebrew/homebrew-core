class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.29.0.tar.gz"
  sha256 "94e86c8202d3fb660f494d33b79017d3226baa9d8f3a2e3147ced90189beede1"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d35339233d919601b1d7abe6ea2455f2a9201ce092cd8e0e2225d56b9c28e505"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba148605d7bf20f3f861278b5f806e11f5b94e003cd04c705016c22ef4e7ffec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "824e2496fd8cec22959cb9ae9d24365b4e0865c801196ae1c54de608af343b06"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c2ed1be55e863d71d4e94e1c98727986f6c90ba96393fdca3ee6d62bca8c8c3"
    sha256 cellar: :any,                 arm64_linux:   "16c524b9d649a999fd0c70482495772275eb9bf095d995f9ea8c44574b3e4722"
    sha256 cellar: :any,                 x86_64_linux:  "a3b38a01ac412c3a6dfc354ff54dc85da094871324189f981736504afbe855ec"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
