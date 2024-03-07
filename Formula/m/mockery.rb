class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.42.0.tar.gz"
  sha256 "3f6bec4b485f61753f4232b21d0ed231e84ec7b9d3d27eba57047d2ea9f584be"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77736996b97492ddd5c8b006c795f4db808aa844f89cdac8351250c93fab32d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c39d1fa39f366dcebca3d275fa45e2c87323e110b1d3b78cb8c0d4483051b12f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29b91cab94dbec9108224793a20e5206ff03e611b710f38ec8db47ff3793950b"
    sha256 cellar: :any_skip_relocation, sonoma:         "104c2c213cf629e2c1ada35c762e84eb693fd00b4ac5e97b8b55172a11c0412e"
    sha256 cellar: :any_skip_relocation, ventura:        "e89d9905c7a19b40244c3e14d3c60d96dde62487c069fd66a6808d28076dbe84"
    sha256 cellar: :any_skip_relocation, monterey:       "7200b2c0955469305c0ba12f6cb13bcdac9a5401e21a11f997f8709e86265582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7be2057210d0cf24c0831bc4bd6c120464996606e71026c83e5cb733175b76e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
