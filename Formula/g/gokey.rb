class Gokey < Formula
  desc "Simple vaultless password manager in Go"
  homepage "https://github.com/cloudflare/gokey"
  url "https://github.com/cloudflare/gokey/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "b9f03491efa3b3481fc78246f62c6786ba19e9c9c8c36461cc8b949081f5896d"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/gokey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39fa37a4675d286bd98d0ccbe73dd401fa1e15cbdcd81c09f639f507121cf96c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39fa37a4675d286bd98d0ccbe73dd401fa1e15cbdcd81c09f639f507121cf96c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39fa37a4675d286bd98d0ccbe73dd401fa1e15cbdcd81c09f639f507121cf96c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4568a3de9d8509a084de977254004036adea7bf78a54246bb750d83950d428b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b087aae267d83a4f2b12521f0d07ddff361e4102f4799d12c4ad24dd77d93b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f5693ea85dd8715215833d03fd95d54cabbdecb1c41242f194109fb59d3882b"
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
