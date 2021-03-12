class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/v0.14.0.tar.gz"
  sha256 "385232478b8552d56429fbe2584950bfbe42e3b611919a31075366a143aae9a9"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b151670fca47d74b6cc6339abb7b225d0208037e07702ee087143caf612cc3cd"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8a763d9e15ad9988122f5cd5f9d1336f37f0f4cbda0b4acf97221a4a682160e"
    sha256 cellar: :any_skip_relocation, catalina:      "a8dab98a2b27dee96655f891749635e67580e19a874c7f0d5e580623eae9868b"
    sha256 cellar: :any_skip_relocation, mojave:        "521dc9c7d93a5485a8d7ac8210794392c052cfb9480cc21a2c5ab331d5709d1a"
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
