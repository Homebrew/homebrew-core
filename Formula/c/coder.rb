class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "18ce177024afabf849a228843f804fd95da3287a5bd5a961ce3a83e53e920047"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e8ebaca5194d37438756162249df33ddb2a5b571b7ea78bf4861ba1024d2d42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "317bfb43c98be5768fe050d81e2603398b750ad14e49c15e72d3a56b65523a68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaaf00202517e74ef4e6ee7bef0433930fb9acfdd82d21bb3f085aec171c5b47"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9f5b50990822ce3d057d52be47d438a2bf76a2a7a8fb39f84d6877bdaace6bf"
    sha256 cellar: :any_skip_relocation, ventura:        "e04b08f089d867c03a922479773964cb78df9f80bd908d7a7e2d52ad2d6440c4"
    sha256 cellar: :any_skip_relocation, monterey:       "5db10ec3a398c7d56990052f8897cdc0a9b151acc3591d2c554305e41b218683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "537a12f445ccb6e99242393e70a87df8c11af43bd4f4fe800eaa304fa435b17e"
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
