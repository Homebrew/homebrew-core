class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.10.2.tar.gz"
  sha256 "e2f82a83dd8487b66142ba81783d5bf48f354e7bfbcac39ffff3b057d2121bb2"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "befd99284ddcbfaf6f5b67e74022cb36e52cd831add1ef8cd6cbd2227ecbb695"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7155b35cdbc2190d4aa939968a1edeb794a53e10760352fa51050f8b486adf85"
    sha256 cellar: :any_skip_relocation, monterey:       "24e13ac28cf47782ff714d3039d0bd3a4dfb6984572fe0b195264902f7a178a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "37309984d78e4bcd5018bff9ecf22a6a82e19283b6c30bf2412679f193020e09"
    sha256 cellar: :any_skip_relocation, catalina:       "ed33cc60a35a08564666178242bd182b2e1a7f1f0ca1a8a5712cc6a3fa2ebe1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf8787bdca7979656460081c3d8fd6b72ace1d7e3e353851e64d25336cf95f2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
