class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "da8da9516fbe2a01db1dab11dda97c7e3096e43a14a7c13202a2f92976aa6db9"
  license "GPL-3.0-or-later"
  head "https://github.com/GopeedLab/gopeed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5371a3df1130b0045c7b3ff44192e50975946b82d41b1fe5db0d04c97377a730"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5348d981526b4777b675a8ffe90369e39ee6fe80f06b3671eb029addcd1c767e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6124c6365947f575520399e761cf2450efb982b29c84b99f823772513838b46f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d256f495e41b9d337c35917427fbcb5b437b0cb6c374f4ff7b9a432983119b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50f2623e58e483e73e7176213c40db30c1f9c5ba3261cb32e4b23f59ad213d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fd3e6d0e1e37c0bc86e55f914817b67ccdae2c6455b6d5abd214cfee1c5e788"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end
