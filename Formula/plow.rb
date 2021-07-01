class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https://github.com/six-ddc/plow"
  url "https://github.com/six-ddc/plow/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "aa579bfa7fee552d84723b6f49d7851759bfd2ff15c9a5d0f216c11a838472a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "55a57d56fb4121d4f031566e97a512606f086b31d22a8d77e82d3de1e7abec58"
    sha256 cellar: :any_skip_relocation, big_sur:       "440d03556132b76a806c5dffef901daa5898ac914584c0e3852599f3506f8b86"
    sha256 cellar: :any_skip_relocation, catalina:      "c8cd64bf0745ef4b2af1c62d0b04f5c10c8ae37ddaa6f66947e3b6f7fee4d13c"
    sha256 cellar: :any_skip_relocation, mojave:        "21eea8db9f2eec92d56993651a482b4f4942434825d8c6da6a1e255a576078fe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = "2xx"
    assert_match output.to_s, shell_output("#{bin}/plow -n 1 https://httpbin.org/get")
  end
end
