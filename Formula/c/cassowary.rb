class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "c94af9c52dd4eb5014da7f12168fcaaa11289443ef13b97a23b2cbdb470b713e"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2c7bb0da64e5da6095a76bf02cd3b07f96c80f91fea181405dcf254e6fa49da6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da17173ae9736a4460e2fa1286ec5f93e83cc565f149095ac8b5675cd73ea44b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63022a7afe20a421a3db5cd6f8fbb26f07334ee09528cb54e06015a34dd3c717"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "037d14633d3862baa5512ad48f32077fbdfeb9e7d758899560d2a545b9ab47eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "857154391f4800d9d72612b2055425165ba1c2649f75d6838075e70270529f97"
    sha256 cellar: :any_skip_relocation, ventura:        "82128a2992ba84b03f089df815af6c99cc447a7e0d7e923f7d8a961deba3e8c2"
    sha256 cellar: :any_skip_relocation, monterey:       "88eee18c92b74b891c779f69408bd8f452e77f38e28c346f5c6714e78dbc582b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6076fd6bd9e1ff5d04a07205b03f1d6d7d3e5bafef6aedec91e776b180c5c564"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cassowary"
  end

  test do
    system(bin/"cassowary", "run", "-u", "http://www.example.com", "-c", "10", "-n", "100", "--json-metrics")
    assert_match "\"base_url\":\"http://www.example.com\"", File.read("#{testpath}/out.json")

    assert_match version.to_s, shell_output("#{bin}/cassowary --version")
  end
end
