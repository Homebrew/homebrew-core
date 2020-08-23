class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/v0.11.0.tar.gz"
  sha256 "60d1bc68b75a59bc5511fd33eb77b14acd735887c74af1bbc4ea68badd271606"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3a6e5b9679a3c5da70142d98eddb6825cb51ba69581e21a485a16c09f56de5f4" => :catalina
    sha256 "e8ee2d0e616f89a395ed1e6b881a4c7f29529ebccd1524af9bb3ba2a23364106" => :mojave
    sha256 "2b723e48851feba06f504d2c5ddd51314c619509df0a380cdd286e439ff35c07" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args, "./cmd/cassowary"
  end

  test do
    system("#{bin}/cassowary", "run", "-u", "http://www.example.com", "-c", "10", "-n", "100", "--json-metrics")
    assert_match "\"base_url\":\"http://www.example.com\"", File.read("#{testpath}/out.json")

    assert_match version.to_s, shell_output("#{bin}/cassowary --version")
  end
end
