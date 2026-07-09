class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.34.5.tar.gz"
  sha256 "f8cef6c6886911db55b7191296a77d285606f93f50d513b8afa736e913f867d5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90e4116742b08e3e2d45b5123fa55ff3418891fbf7dcf3e0c9b929a6505f7c93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dec2c8f4bec90f342b1ab988097918979e5c96e6562171be05a973dc30ada74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3536f15257a8ffeadcc466aa85120b3603fedf52bee62a467f81f7a7b4c9f6b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cf7e989480ab1f8709ca4c27232ecbb6e1d87bba8ccd8393281eb7eb0d8b0a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ab7d7b88897c70865b1f0b4e3f71a4e466bc0898c508bb38cf20b91eda247a2"
    sha256 cellar: :any,                 x86_64_linux:  "5fa689a36881f119e87c483d3de2a92627fb99b9c8446cb91e9b2fbcfcf47fc7"
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
