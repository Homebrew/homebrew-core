class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.22.tar.gz"
  sha256 "ae725092f085be1685933fac19c6a3af1bd5da8deb4847a0fb3e11a39db460ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "973fcd0d0b611af7ed8a604af05a0229d5f450a9040b2904e8a6cce15f903804"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4cb699e4a618f4866eb8e49dc959b9bcca528c35e2fab868690a329b9882127"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47b2f972f572cd890dd397a655e4eb61b2553452388c083bd04a8087a3dfaf78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd57510273931d6b3c9de68227888b5dd283198fc53f339076cf8d6734b671ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "38ec8d520cbe4ac7d0e0098452a68c4cd7b193b5b6328e3c18da2245a847b9f5"
    sha256 cellar: :any_skip_relocation, ventura:        "64138d5c051ecd542e530c42d43233ed27d82fd51887fe84592141bf882a7545"
    sha256 cellar: :any_skip_relocation, monterey:       "8a31e1b10500be72c5db6a2e9b8d1543be5b52f0fb2d6b9c44ddfadc0b653cfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "33fba3095bafee14fd9f15c1fcdb824d8b1d07b6e12c14186d26ae4da49e0e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d909685126d40bc2f5d12f2f34871cc6c8de9f0cb9c8541a84f1242b48c7854"
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
