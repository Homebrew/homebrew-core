class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.18.3.tar.gz"
  sha256 "8e92cf9e1c1cc9e40079223eca865a3e821e593a6e90017c0bf6c78499628704"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c02bf125d72e0e6ff57b530c970e405a0852dc1fdbd7e4e44ef69d931ddc2907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e12667799edabfec2105fc24382311c949fbd311123152681d580f675ae8951"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4c3b9ccfd6aa692c3a6842d16829e7f811175c3e350369bd9e16e88fc2b8af5"
    sha256 cellar: :any_skip_relocation, sonoma:        "19b0f63963db7616ec42e65b869648489cc915bb1ebc5dc4e9ec747b3250d0bd"
    sha256 cellar: :any_skip_relocation, ventura:       "992a39703580f00521f2df817bc49b067ba7f94f10c8413c4be877297f15618d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09d30a4dc930dcda5a242b5d0f3aea21b47dbaa61719f36608e87abad9a1749c"
  end

  depends_on "go" => :build

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
