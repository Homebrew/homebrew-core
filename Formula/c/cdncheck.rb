class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.30.tar.gz"
  sha256 "9b507017a08189a3c8a9a244453eb3427348f2fe05bc15c25fbaa854c082833e"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd39c707526785e7e630206e3a355101efbec79a0c55dbd82bb17ca2fde083cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b394cc33fffaa1828878c902c72f7eef83f84f163c05dcd9be79993a00bd6e77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1080c58ac06baad495c6fe8457eaef79798a97772eff0694ee32f02b37084766"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d2e973bbf710b9a1513a17c2908cf0a5c7d7b902cf2ee79add5ac090009e445"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c5a7769748bd9fb114883516cca9f54c884ba3f772a1ee974193800448480d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92150e708455ed36aac7df684f233c2e902ef70ad892124cf076153f189423f"
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
