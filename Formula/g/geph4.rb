class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.32.tar.gz"
  sha256 "fd6585717448b796d90b7b6dadd609c86c806ee7b4c9f0a21e27ffb47e8ff59c"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc9feafe9c20d28772706c2fabdcf31a2bb9516b01ed39a780978d7c89a0335f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12003483d66014286b643b460da29669a749fcd7dbe4e1725ccf3aca9d66ae8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aaf50eb8d06e7a2b8baea74bb6e93f1191daf10fbfbc99fa97bee176327f244"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "340080a0bcac0f94e3171c059c5de370822c9d2880ff0b67d315aeaf72234d67"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1f9f47bcdd806687fbe6797689ac67e23d3519325c96322022ce1e6a80360c7"
    sha256 cellar: :any_skip_relocation, ventura:       "a64f9f02478d079fa19a0a66efb0860bc15233d59ecc2b4d266fdd32188225d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddfe22bccde62ad86f06c9060a8c3c2897fbc0f49e455d69c1aa808e917bae46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde6c9148a586e0bf317a3991e2567231fcf15be78b1caa2ef340ff0f399c494"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    rm_r(buildpath/".cargo")
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)
    assert_match "incorrect credentials", output

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
