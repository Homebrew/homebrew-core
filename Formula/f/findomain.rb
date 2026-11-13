class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/refs/tags/11.0.0.tar.gz"
  sha256 "94a6980136ac1d96034bf2f4b30d4fab15f4c2b4dc1e99dfe226b7e7ca79ae37"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13657fc94b60b68fa80b2d393b81c93b5d9a7d975fb9205e4d5e6ab84b5a34bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d74ab905a19e5eb0aae6e1495eb4248bc5738b246592e8a252ea3c2c53a18e12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb6018f90ef362ab606375f48eb14516c5f7db69131aa0ff32a1de64e4d1e3b4"
    sha256 cellar: :any,                 arm64_linux:       "fe80de3650973d0fcb15d36e2c842f0d7e2e3a2f227a7be84c6a2096ea8cbe65"
    sha256 cellar: :any,                 x86_64_linux:      "6344045ce12069850d94066dace6654b38e044c4c028366cdc9e162254fc8eba"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl)

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
