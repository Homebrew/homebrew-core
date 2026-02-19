class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.29.6.tar.gz"
  sha256 "3d66744739a9c6a2d16e4ad0ac39847c0966bd79ced737380b04da14556c0939"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e790ac1da35df5675ef7b9f4a2392dbd66f54b1a19fa7d100f4f99aee8d2bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de53b9a8290cf5ad678ebe86b9db22a0975b423012630f4e2f2736dc3f95b11d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b20591835c62bd39b0db393ad9d2a506cf943d38ac926fe0a7d09cde0c9ed5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e0064d3e00bcde0750921957b4453fb3b466f206dd292572e5b87126aabeeeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87706d73f81b54de8d05056dba5ae5a9b9e1cac0a17dc77d819e1fa7c66138fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98868234846bb2592001065f9fe2fa1236d2c1c8dec9606959adb0403cdb5c65"
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
