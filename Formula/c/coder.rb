class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "2b80977969b976f449847d4d60d66da79b589edb7d5c8eb572ffd3089f62b844"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a86bc0b245d772231368c1d1b22e478ce0dc9536446ef9411efeedc654cefe5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f90fbe20d78ecf637b9c74e07d669bab1fed88c02143aa54f2769cc5367ae62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "046b3563a9de0b46747d0ee125fa1b60695d84911a4e1afe741df2ec67a3f431"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4eec265621e7b76270e7a6cf516f7ca743958b510798b0604e44be9b3914acd"
    sha256 cellar: :any_skip_relocation, ventura:        "cc676fb2a627cf48e50f10b37a540412b58fd6d873543305ed72f175c71a1021"
    sha256 cellar: :any_skip_relocation, monterey:       "cda4e64f80d0600dd8c0e54c8c3356e8577899a5f6e8e81818f61f8ebe4f2242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83d98955efaa9abe60f40d2fbb4b5c3a0bae71b9dcea11e666de060644aadf3"
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
