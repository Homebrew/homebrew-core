class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.21.tar.gz"
  sha256 "9e30f96e9483b60762eceeb918eab5d245d8763db0fd18996b3a7f9dc2adfcdf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "481a4fbcb5579cf93451e7612a36c2fefba0bfaa5b5e3cb85c4dc2cd5af90c0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02db01c68e446b329b67bfca1a0d0898442431658ce364094684a63b112e0849"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75592d929849110ca88472ec17fb98d75f2e1f39b8d7f2f435a9496876bbb973"
    sha256 cellar: :any_skip_relocation, ventura:        "6c09d5ad35e8148d716880d485a693c5dd6d0650fa9a410d5a27cda162b7ca01"
    sha256 cellar: :any_skip_relocation, monterey:       "62b6344030a8b102e0b438b6d856b453c218c4d496ab978d8b1cc90eae2219c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b4bb4517449520a0f56c698cff71a601882c7a885a922e5ed6f6e7292d8aff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4b3908584f4df70a129dbd50fd53aa0a0c7995dbe024d770270a46e18749559"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
