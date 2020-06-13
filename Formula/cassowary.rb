class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/v0.11.0.tar.gz"
  sha256 "60d1bc68b75a59bc5511fd33eb77b14acd735887c74af1bbc4ea68badd271606"
  head "https://github.com/rogerwelin/cassowary.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a57a592abfb7ed0e997eea55a3478fcde7fe115a2b2281afb33a0f0f55b83bd" => :catalina
    sha256 "5e28763d9b72a25b8fdfaf913e6dacacc777e82bed399e875e3dda1d882dbba2" => :mojave
    sha256 "e05b0b8d38265cbb05223f2f4a5433f47991e74185d1a9673c0bac1a3c05600d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args, "./cmd/cassowary"
  end

  test do
    system("#{bin}/cassowary run -u http://www.example.com -c 10 -n 100 --json-metrics")
    assert_match "\"base_url\":\"http://www.example.com\"", File.read("#{testpath}/out.json")

    assert_match version.to_s, shell_output("#{bin}/cassowary --version")
  end
end
