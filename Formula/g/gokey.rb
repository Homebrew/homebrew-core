class Gokey < Formula
  desc "Simple vaultless password manager in Go"
  homepage "https://github.com/cloudflare/gokey"
  url "https://github.com/cloudflare/gokey/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ddf693b10012b44c20b6780e239028b9617590a6912f47d8d59470b560c83249"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/gokey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81186a07e4187a1051296ae90494b6f4cb291083ff08076902033454ab018608"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81186a07e4187a1051296ae90494b6f4cb291083ff08076902033454ab018608"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81186a07e4187a1051296ae90494b6f4cb291083ff08076902033454ab018608"
    sha256 cellar: :any_skip_relocation, sonoma:        "759c0ca21f9300b638995e96c41218aa4c03284a61acca87c3fb84f1e5da1e06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0b3f59fe04d5c7c0696e1605a56fa4ddd99d3e563dfec934d087538a6851156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5159a7d0e167e26ba1ce8b29cebc9e48e019627c99326e394df8b08e66d958d"
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
