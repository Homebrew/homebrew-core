class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.15.0.tar.gz"
  sha256 "6d708828e4641c5c596376300363a24863975ff0a5567e26affc4197d498fed3"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2eb92f3c602240800bfbd37eafa43213d29f3ca0840d60ed64d44dff82c5ea4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a869c896fe0bf7f35e2c840f3e93fec7640a6c0b0425730cc66b344c80cecb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a3e28af9a1c1236121392a6a79d0193b2b4aae59b4d96d52705e8a8ebaea9c6"
    sha256 cellar: :any_skip_relocation, ventura:        "6b611ff5c6678a0b259d2d26cf9a64740559c5742cf108434c40badf87f0607f"
    sha256 cellar: :any_skip_relocation, monterey:       "8f4d38cf9b8a3eb7dff78e3f9552f5379d42bb5eec6b1f9d197496d4ab46ed22"
    sha256 cellar: :any_skip_relocation, big_sur:        "bab71cfd824b664fe34f4d8deeee81c03e0778e9a8816ac889314b24ded57ac6"
    sha256 cellar: :any_skip_relocation, catalina:       "5934b6ac5b2724389661fa817c5567ee601a3f6c5dc271ea72f5b4fb9c0f9ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87f41202cc55d8352d6e91b83ac8fd27041187a6d966fda059bd3656c155ede8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
