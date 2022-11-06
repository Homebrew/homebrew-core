class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.155.tar.gz"
  sha256 "e3585c24a7aec22e95ca7d5235539dc4d3195aca8a65dd2c130ae12e21dbc9f5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0924b8d7156b58aae95303cffeb6cba6bd566300004771f462d182efb3ecf87b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ff0fae51ed2165a4af24f3fa9aa88e7780fb05a7996edf0c4325d4319fa6ba7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50f2d968bc485bc91db99d8967ac1e1cd7019b3891cd9cf6a1c4d6915f71a702"
    sha256 cellar: :any_skip_relocation, monterey:       "b35ded3ce5b46d1ddd5a099109292b5d9856d75cc2c4a19d29178c3d9f86ccbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e80b88a8b82c0931520846af6aff0598534ef7c321bd7ccac1b17fbc63a63e5"
    sha256 cellar: :any_skip_relocation, catalina:       "d6a8a96294e886fcb6d089bf53b517319560ea1c18e6c0e674066a3f72a6b187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6b2f30f5bc508d7d029449acb1315b7ce8611a5b464aae5054210717fc076bb"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
