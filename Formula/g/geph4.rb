class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.27.tar.gz"
  sha256 "b3ab605402a24ccea64981cbe74ba6b501624f370c0817b371057cb0f7eeeb0f"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3926384fa9dbec93ca4a105bc87a9a03e8d0a000caeaa2aba5ade01adb08640e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "972916017b464c7bbb24e96cca9c4d60a2182321d9bc9302657f443b45ba50be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e10f12833ebc713efffdb6eed292cb00731ba5cabc49f55c61e39a6bbccc1da6"
    sha256 cellar: :any_skip_relocation, sonoma:        "58082aaea4b0e36eb3214c46f8b07078a22d2ecc1184d4c0d9270a3298d977a5"
    sha256 cellar: :any_skip_relocation, ventura:       "e04466053d9792637b19368be5d29c393e1b097403a359e7851b7c8b21bd32dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2733d113b50c014e7fb4d9861508aed201d39657abf3f96c0e024e841c837e88"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
