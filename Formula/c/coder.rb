class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "e6a4a1c3212246f745aaad6788d88c0d3a906dd383182f0538fa76238eb6e636"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fee3e0d0b8d37ea33867c996dc7db874ee2b6f8984c9ba484f5d14f7ff14b3fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e921b030063e49dabb375c3fa6d26f0e18604fd72ab05a016a1c46824ac8482d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "133a2392db43b782eb78e878d31fdaa1709c0c547e0aa411cc44e09dddb76205"
    sha256 cellar: :any_skip_relocation, sonoma:         "fffe5c318a8ad13bd188c865324aada728fb75eb60471584fa4e8474f41a5068"
    sha256 cellar: :any_skip_relocation, ventura:        "408c732061eb99f3786d02031dad710d4d8ea5e50e3c23bc183fa3e7170861b5"
    sha256 cellar: :any_skip_relocation, monterey:       "a4f957c1b75e4fa472dcc3557d620b6e11d5f5b6ed95b97611f00b680433429f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e598d33e244917aa016dd622c298e32b2d7faa4cccff9968537178d314e14191"
  end

  depends_on "go@1.21" => :build # see https://github.com/coder/coder/issues/11342

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
