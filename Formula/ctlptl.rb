class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.9.tar.gz"
  sha256 "94332ed48728e59f9d07005909aa65d9c99ccec9914447710007ecc08553cad8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f4074347bfbd7744629907146adecb1ec61c94ff5788e942abb886f00608ad2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af6014518f231a334d14bf61c630b7b7743cdd0283aa3c5910b452f77eee16d2"
    sha256 cellar: :any_skip_relocation, monterey:       "9ce2173da6b225e26601aa3fab6c2149b80802ab410ad40941806d85f528a4c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "15d02a0c2e2edc11e499756adb9bd134051494e23a5ac98c715c440a76e859e4"
    sha256 cellar: :any_skip_relocation, catalina:       "84e2cd4400917a952230c54448f1ab0ba9d0aa518ef3a3db67eafb3e5a3f0ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f19ab78d937dbf56f1b86d878397f6a15ce52a88fe9fb45bd4af32667f95fb4"
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
