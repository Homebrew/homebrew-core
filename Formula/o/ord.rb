class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.23.1.tar.gz"
  sha256 "bacd90dbd470883035edcaba1ff85ea34360d35b93c0b7539dfe94399fdca184"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4ee2eaba425e6410dfdc382fd2f3defef29ae493efc8a5b91966a99a8b17cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2abed74bff0ae175a7c224b4feee92f0ab63ec9eb8341304fd5117e1413b98fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d738ef2c19ce1c82d782c09b76c720a3ccf02fa57d252e84683cf0e1d2a99f9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8a4057e0162e8ab8e81a3da38fc71ba9898b54b80e5452adbc7c18dc2f0165d"
    sha256 cellar: :any_skip_relocation, ventura:       "bd82a40dcc24ffe1551d783cf18cc1f3a7e424148efd0860e2448b61876442b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d91b7ec987202d1855e304795d345732698e0d4e3ea61d984fd1b8209af106f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3011ef48bbc7057fa537d216751b77379cce59439f6d544f494af01b2931aa0"
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

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
