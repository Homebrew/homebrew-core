class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "a0e29820a262c9e1d771ca25f57eb5b3935f0bb43dc1f1de464adca8c714feec"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1043a8b63afef5285c0ef5a7e15ce9d81f5d405aa6699f909e81f01a45e8fbd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d6df406bf90afb0902f22ac7acd8b7aabdb1c414651087e520a784e3ce5a36e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c183c998a8406a7de0bffa7821c2e32fa93545e82f12e2c271b3922143aad595"
    sha256 cellar: :any_skip_relocation, sonoma:         "3378c98ce7722d3663686880779fc49cb6ac171b59a4b00a050637e2039129e0"
    sha256 cellar: :any_skip_relocation, ventura:        "4dc19e92933811c66bd9241da07bc82de386e7290f66b757f0274342e4570628"
    sha256 cellar: :any_skip_relocation, monterey:       "d65af8a7e39af96d16c063f9925f36628633e07199dc427e18f2da292071de1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d0404face75b686ddb1d1248a16c4f4383c166b70b2a30768f047239930ae65"
  end

  depends_on "go@1.21" => :build # see https://github.com/coder/coder/issues/11342

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
