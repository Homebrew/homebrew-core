class Jprq < Formula
  desc "Join Public Router, Quickly"
  homepage "https://jprq.io/"
  url "https://github.com/azimjohn/jprq/archive/refs/tags/2.3.tar.gz"
  sha256 "b134d981e37dae05cd3d1a5451fdf63d7ef1b8b23ec4cc99bdbcd4951bfdbf13"
  license "BSD-3-Clause"
  head "https://github.com/azimjohn/jprq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "405bae408ae0f4b6cc16b2397fad514dfbc78615775a9505dd157fef0e412a54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2ac3c91e30779722a50d98b44dd8b29d33ce020676761b232d0100c27c8e97e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66a0567935070ced5c8a72278654c0c5dfc1980943896e61bc94530c90c36a06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c566cb561847a5bbdcba4320d510ae68654e669c48565c8c654cf2dc012ec9cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "15827109152237c45fb1f6fee0bb37a82a4dcbc7a45f87b07b51c68ad7d48f37"
    sha256 cellar: :any_skip_relocation, ventura:        "0f3bf8f6cf6e2bd8821fbc247206803ee620b30a351ee3d859833103fac4c8f5"
    sha256 cellar: :any_skip_relocation, monterey:       "21cd98befecfacea7c5748e419c81ddb31135871cf7c6cddb8a00f6060c92136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aefa837e3b7be3ecb446440d740fb2a84dab6a73f5382ae140971ec2d3c2f19c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cli"
  end

  test do
    assert_match "auth token has been set", shell_output("#{bin}/jprq auth jprqbolmagin 2>&1")
    output = shell_output("#{bin}/jprq serve #{testpath} 2>&1", 1)
    assert_match "authentication failed", output

    assert_match version.to_s, shell_output("#{bin}/jprq --version 2>&1")
  end
end
