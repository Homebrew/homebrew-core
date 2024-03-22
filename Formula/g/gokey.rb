class Gokey < Formula
  desc "Simple vaultless password manager in Go"
  homepage "https://github.com/cloudflare/gokey"
  url "https://github.com/cloudflare/gokey/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "31144a7906682acf25279c5c0958aff2273c24f83da0d9ad27962fbd9c3d7d5b"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/gokey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a7cc8f8fdda87bb1ecb9fa2a6ee67488428299326520be58774bce205266ad6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79c2de4a09b14270dbb34a722bf3de6b15f8139d7bf05f216b6ed79d7a1f8911"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12d61d5319e53dee658e15b69e69744833092e45adea973390ad3c770c90e281"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "289fb7726ca245695374d2e7fc51fce988e748acda51adf05aa83d19e7b81259"
    sha256 cellar: :any_skip_relocation, sonoma:         "9922ad25d99d6387bb214208d91c41b28b4bff3429c99c18bd19e15405a26c8f"
    sha256 cellar: :any_skip_relocation, ventura:        "d6d274f4e2d9f22efcf87d576496061701e8e4aa8a1732d1ea34791b0eb2779d"
    sha256 cellar: :any_skip_relocation, monterey:       "9aec79e51fc11ba5db465a4ecd2b78c80fd4dfeee3f4382f16ab59e6e7eb51d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "49f8a560cbaff9a6d48656fbabe3b7ca23e743dc6b53394fa89778879e0be08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf427d0e4e3cba9c647cc28626c957ff00ffb09af87c9e9d68c6dab7aec033d"
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
