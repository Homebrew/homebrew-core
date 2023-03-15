class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.63.0.tar.gz"
  sha256 "9ad4b057b9482f67817f9cf69d70c1160664340138bce9471abaa185119e40cd"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b47304ff279cea7da5fffb7a7085a1ac2cf0ea81078b4853af0ace0da440a40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf9caa35ec42a9a39fd9c77583b26a5a1abde35a7610608d29c198721f73b3d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aae94a5b86f28ec03a2b7c3ac3480b1eccb86ee53be7872227bf2eaa3d9d1ac0"
    sha256 cellar: :any_skip_relocation, ventura:        "054494fbe1bbc42222770c9021b68a2d1796bb4ba2aba908c4939fa5d41adcd6"
    sha256 cellar: :any_skip_relocation, monterey:       "d506098bcc71c6aef9a5601754f584942080bab9c4dddfad3aebc610d69ad0bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "5720e59bc7050e5f0c82cde3644514b61de16492a7cbc42573afa0bb48eee2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6746b88b741e70a3ec5ff527af3d9da40c5d58df2ba580550e280af09237c85e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
