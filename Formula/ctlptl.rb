class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.19.tar.gz"
  sha256 "66506c0d328d692065f7da3947eebb49ea7024ce07d6d8f99f23fed86f2bfce1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4be6b66511ea97626723fe3156ac1d3c1045d6af27ef16e57066be20c9d5086"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91f81062156a4db41f36a0afc904906f3b8dcfd6581970e9a9e79cb3fbb1e2f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4437925e952d10f2001b3fdc00570c2a2a5e3a73cd2219bdc2f8b4723bc1ec68"
    sha256 cellar: :any_skip_relocation, ventura:        "316f7dd4047fa02de6c1e27bd7e5b47fcb9a67e4198a30aebe59ffa8ae45ccc0"
    sha256 cellar: :any_skip_relocation, monterey:       "e40b29850dd46c4b1085bd4dde1eec60ec6a397c68b91683e7ce7b35e52f3a0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c5d75917613a11caeef8c3e27c183961056917ff2d41b29b53c9bc0f22256d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c790f2ef349ece8807366079d37b313ddcc4e0c7e86d2a99edceac7df400ff9"
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
