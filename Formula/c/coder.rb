class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.31.9.tar.gz"
  sha256 "ff99562227a584ab9c96451700092f8eb4398a7aa4428457b7c138d4d38407fd"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "917cc20650465ea70b61221e3f04d6f3282d4f5b36ed67737c069baabc046f09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe542d368646a8121705648058f43c0b1b771918718de0778b02f111a29f4ab6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acc900df108c6d40a90cc79ec6206f81ab46131d803c9c40d902cfe057d931f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "23a5d5b1bcad0442b7b0d3fd6c5772a564dc3e71ebadff9c61d12a0ecfd3655f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45af9001249621d93b63449bfbe407a427b18efd4df4159f4fd57cc892196275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb628918638cc5119caad2c3f4e9c10c25b2c721dfaf90a6a92a4f1c82db70dd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
