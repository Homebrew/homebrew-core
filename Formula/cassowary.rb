class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/v0.12.1.tar.gz"
  sha256 "091bc850ec0e1a83d9e909650e4f011a6176c62b1059a99815e795b79362d861"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00fcb2998b4a2f4773e7b63370bc59859cd8686f42a0c916df02ba6639b6a8de"
    sha256 cellar: :any_skip_relocation, big_sur:       "66460d5be2e3a3ef3f8b27c6f6bec1f3414d1617a05ab7750f51a57e8ba79e5e"
    sha256 cellar: :any_skip_relocation, catalina:      "8a4c292f05f1ca219faf9a0547200736883859a7148c8b91a775cce26929cdc4"
    sha256 cellar: :any_skip_relocation, mojave:        "3bf88505d1a199c29ed4453d394027939803d1a31116af5b1f4917493c8c6401"
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
