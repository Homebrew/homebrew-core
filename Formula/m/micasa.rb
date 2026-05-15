class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/micasa-dev/micasa/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "d864680af382d4a11e3d2ca789b0b62bafe16a6f8bee39761375c2e185c9412e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81b8071d5523d401319ecbca7625d1404dba33790f4896b6575d3ada8f8a3fab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81b8071d5523d401319ecbca7625d1404dba33790f4896b6575d3ada8f8a3fab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81b8071d5523d401319ecbca7625d1404dba33790f4896b6575d3ada8f8a3fab"
    sha256 cellar: :any_skip_relocation, sonoma:        "c719d6374b7ed19dd173b9b3f0e35515c8835fc7154cbf4147c5efacb2290c48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66757214ce33272ae68640ba99166aae6ba752d52b18f3c6ff7cf0e6dacd99c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6c791d836fcbde4ce5070ff4f32b8977dd9562709372ee9ab8d37f1311cbb22"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    system bin/"micasa", "demo", "--seed-only", testpath/"demo.db"
    assert_path_exists testpath/"demo.db"
  end
end
