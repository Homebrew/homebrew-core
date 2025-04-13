class Gokey < Formula
  desc "Simple vaultless password manager in Go"
  homepage "https://github.com/cloudflare/gokey"
  url "https://github.com/cloudflare/gokey/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "eb7e03f2bfec07d386d62eab6a7a7fc137cb5c962f7a2c6aa525268dc8701c0a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/gokey.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c48361701ef4bb0cb240cac294c443a25c0bbf0c052491374ece690251004c50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c48361701ef4bb0cb240cac294c443a25c0bbf0c052491374ece690251004c50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c48361701ef4bb0cb240cac294c443a25c0bbf0c052491374ece690251004c50"
    sha256 cellar: :any_skip_relocation, sonoma:        "60a0379dcee805100101fc743bca36ac50142bb12b7b33aad7b904f47d47691e"
    sha256 cellar: :any_skip_relocation, ventura:       "60a0379dcee805100101fc743bca36ac50142bb12b7b33aad7b904f47d47691e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b858ad23afe1d56612a5e2a586f1d24b5b87acadc282d104e44ff7a2959d425"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gokey"

    system "go-md2man", "-in=gokey.1.md", "-out=gokey.1"
    man1.install "gokey.1"
  end

  test do
    output = shell_output("#{bin}/gokey -p super-secret-master-password -r example.com -l 32")
    assert_equal "&Aay/aoUlTa[u0b6LAm3l'UuE.$xDq-x", output
  end
end
