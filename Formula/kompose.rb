class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.28.0.tar.gz"
  sha256 "6afd873246f53cd056a51c6d95377ce8da020e4a1da4e591d4520e2c160a6de9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5260435bd2e657104334e93bf0047360e173c8149e36049bc14b49bfe0ea203"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1457bdf346c96dbec5a8cfdbb3ca2ba430466e011f239975841904aed2250dea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c45bd3bb4e448d08145c04dd6440592f464e7837bd5278e833dfdff5b4f6fb21"
    sha256 cellar: :any_skip_relocation, ventura:        "9695aae955a8122bf78c447846ef3e9ad2a5be67bc779ae3fefed9d07958a25a"
    sha256 cellar: :any_skip_relocation, monterey:       "05070f9b6ff9f6177dd299e12f37115f38cbb82d57a535587e604eeb3731e06d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2206869fb86d72ed2b578c84883e3fecd3794b4010c4febeda0da3fd96f11b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dbfd0d3304cf727012fdd7c26f946d47833884c70524dc31989de13cb473cdd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
