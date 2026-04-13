class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.5.0.tar.gz"
  sha256 "a5f97c4d8a5c168e5e5ae3368c5a2c0ced74c668f562004cbf849cd16a136fcf"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9ee826e12b18611f3bec40d9e8a97c705c3a323099195f03aa309e593f971ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfb96bd369fae9f8ea6ad6632582b060206843074b57161344c563f0b3c2ae54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c249cd9617a0bff08a3a27ba62a61da57baa19a02f8c82fd26a54780a3d124d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdfa314eff66e7192f5a34d8cf5831efd9921dd5d90ea9ae1a136fc4c8fef64e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ce8da52c8abd9a6d582ee8e8dc4a4490187fd450a96414a0165197fdeee5719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fb1f64ed722966362e2d5a095cb23e219ae3d3da92ff7995b8d7b536321afb2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "no recognized payment protocol"
    assert_match expected, shell_output("#{bin}/pay --output=text fetch https://httpbin.org/status/402 2>&1")
  end
end
