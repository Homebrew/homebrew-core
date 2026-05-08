class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.34.tar.gz"
  sha256 "76ba73ea290de400341d53c2bc4f33007b76886ba006743fe9cb7392e07f1d1a"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08d04b7985df3e551401103a403ba0a8147dae7373cbba0c947f50b7b3c4368a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf5c01156d78801816eda0230955fb9cbf4ea71172c5f546efc245a05f7c3619"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d69b299df1f578349dd3b7b35f9618e5e3938823097a056132fa89319be7ab3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed268c60fb152464765930aad84bb182c5a66a9399414801ffdcabe9a6fe7f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d05813b856455fa9f2dbb458bc8ed15f482cf5f38be6f9d6135d15b631a805df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f164cd3cf138665d4e55c48009dc8ee2519c7d0876e0b1f1549a6e7e8bdac64e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
