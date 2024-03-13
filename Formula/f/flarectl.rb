class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.90.0.tar.gz"
  sha256 "410ae42dd9b50660fa61a4892fb3e973342af2638a87cd98211c223a0536c666"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e0de3f0e9eae55af092eb8d56f1ea3ba4e35a083ac3ec7d332503b3181e3bf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9f25707af80f73f5f7388f152669571082ddab9a1072eecc3c1f9f9a19b37d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c65f814b26c8c7371ded1e96c30a1df28973c59482ba2632cb476e6f33940642"
    sha256 cellar: :any_skip_relocation, sonoma:         "57f3d1c7785ee63d2cf71f39e71f69c3d96cd42b434a4c7045818eeb645c12cc"
    sha256 cellar: :any_skip_relocation, ventura:        "7357cd32b5d298a154556f034f56444bdd12565094525a328de174619527b245"
    sha256 cellar: :any_skip_relocation, monterey:       "92eb43adaaf691f43860a91f64dd9fa8a11e2093181f3673acc64370b7d078b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a04521dd41825f33a8baf371d02448137d438e7fe64783768eca7e0777d8ec8d"
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
