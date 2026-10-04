class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://github.com/jdx/packslip/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "57d405a69280a4166a29530a10b5b63987c4123b35bd2f4550f69db19d1507f0"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/packslip --version")
  end
end
