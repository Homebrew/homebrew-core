class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.31.tar.gz"
  sha256 "b77feda544575f3e9a37a9db64dfad14978598e295f8910a1bca484d8e184317"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7026a6d2dd20f4c6bf5b1421a5465217b9b7c64ed28397de7bef10e27e96abe3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32fe47060b38513725259eb862277194404a0f87030399f0112f915b16f677d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda89378270123a248a6d62189484689c7986fca229ae7833f5e6e1d510c92d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7fbd1aba58e1fbc41274a8dcc24fe5efc6656731650780987ec4a942cea1219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d23efffbe0296f16e532c646ebf687fb467d4608489bb9e9041ccb6525beeb2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ae3027fbbed13f7e26f2d2a88c02b3f288654c11bf5fc9f8c264636a9e24d11"
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
