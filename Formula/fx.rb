class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/23.2.0.tar.gz"
  sha256 "dc6d311704e547d900cec2b2287ffc1add01c7a91915ca832c50866786f42d09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "154443ffc20ba081e5c9b34c84a66c41559d2b361653d915a4e996603b484b7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "154443ffc20ba081e5c9b34c84a66c41559d2b361653d915a4e996603b484b7f"
    sha256 cellar: :any_skip_relocation, monterey:       "47266f078c2770a2f51c40efb87189b78c821f4a9aa7c4e7c38eddb639458c88"
    sha256 cellar: :any_skip_relocation, big_sur:        "47266f078c2770a2f51c40efb87189b78c821f4a9aa7c4e7c38eddb639458c88"
    sha256 cellar: :any_skip_relocation, catalina:       "47266f078c2770a2f51c40efb87189b78c821f4a9aa7c4e7c38eddb639458c88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b36c8d6e77166feefa84f0a55b411bcd795b24d75e0933cf3c3b43a51d9abf76"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output(bin/"fx", 42).strip
  end
end
