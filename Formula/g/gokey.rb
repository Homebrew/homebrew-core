class Gokey < Formula
  desc "Simple vaultless password manager in Go"
  homepage "https://github.com/cloudflare/gokey"
  url "https://github.com/cloudflare/gokey/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "eb7e03f2bfec07d386d62eab6a7a7fc137cb5c962f7a2c6aa525268dc8701c0a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/gokey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "65505988ee30e521ce2a597550d9c340048fde87b7a50940b5e12d634d7aeead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ae5486ec1ab213ec6288012f1d9b3c71edaf8e384b314e7d2a09786606fda76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3213372d1b8e6a45657d9ca0c7f6e14bae6086f20c428f3146474260c5dcdaea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "979193bc7c66e5e0d14eae989218ee81585b896ada2051657eed4fa025c19b58"
    sha256 cellar: :any_skip_relocation, sonoma:         "0056b2877b3ae64ebaa2da2a03210110fbc75b6db707a642624e5edae500d04b"
    sha256 cellar: :any_skip_relocation, ventura:        "25c79c864890415b28ad725e01b4af05234ee1731c4fba4163eba5f4cb17d229"
    sha256 cellar: :any_skip_relocation, monterey:       "702791caffb7b265896f10c66018a5f58658a7f908d01c7b8a1ffb83eb061368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dafc7e2db8633f7f99f5c7fafe8bfb2ce21380bf2f0bfe3c0af87252e139013c"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gokey"
    system "go-md2man", "-in=gokey.1.md", "-out=gokey.1"
    man1.install "gokey.1"
  end

  test do
    output = shell_output("#{bin}/gokey -p super-secret-master-password -r example.com -l 32")
    assert_equal "&Aay/aoUlTa[u0b6LAm3l'UuE.$xDq-x", output
  end
end
