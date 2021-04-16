class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.16.0.tar.gz"
  sha256 "4ac9c510b1fa1fc7d7fdebac4dfbd91d3fdb15b6e2bba8c78d5268a81328e874"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41e0aade2dce1425c9487369a66771706887c2096fbd5a79bad1353ad642e1bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "261de70b759b8ae16e7fad56eadd1d7f7e5026fc28d0e75c06550f889dbd678b"
    sha256 cellar: :any_skip_relocation, catalina:      "70a8366ef4abdbbac4605d301936d8e284753692afeeeb5946a101da17ffb4a4"
    sha256 cellar: :any_skip_relocation, mojave:        "959d0d4a80f2b583aa3e3f5ea1405b73adcd23cd82ab029ab1d3f33ec829631f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "HTTP status 400: Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
