class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.34.tar.gz"
  sha256 "ae31ac4860c23d0a66528fb9145df399e8e0d27e995952b1692003d17d4626e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ac9e2743964cacaa907a42cee81b73fef2c3da06905c6898c034538a0ebad9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cdd3f21bb6934304a2612e0932b9c10637b1ac162e9705120cf5ac5be350d7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5d9d1b7bc197dd582440ad085279d06fe2d15b4408d98c69e3023f4f80030e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d88ce43aea955aa4b6d5cd9633782d3685a29548444c925c58c127b614fb038b"
    sha256 cellar: :any_skip_relocation, ventura:       "9e6dffe5106cacbaac9e0b3be25cc967360b39a91b51bfbc45089de96b509fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a69a8f228fef6d58ea7ad751081c96f868ce957cff12218a2a800e6434a5c00"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
