class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "672981232e2ae859f831de5d3e5a9f0c749739bcc41c0b17d511ca186ff56b93"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a7fa7dd4130946381ec6fae85f04e7584ddc52563ad2ff61670613909f1f53b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36b12418eaf761da0ed6592e46a0ad78ed781fbc46fa3abec1123b36d3ec0985"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60941c6169e96da32bd6de8db7a4071da6dd3beb7feeb484595d365a313ef387"
    sha256 cellar: :any_skip_relocation, ventura:        "86be507a0d8efe77533d1bfd9d1fb6011b42f2de3d63ee48183bc265f7a2b582"
    sha256 cellar: :any_skip_relocation, monterey:       "f3e41c09597e682425d016c56a1599cb8c60426bf5d13ee33636b94c3eea38e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d6d2762f20c5872189c16444b9d7933a7d6c90e9fc667fa6f79fd1047652d78"
    sha256 cellar: :any_skip_relocation, catalina:       "170d7c5338973244e7cb0fb14643855282999d85000b7eefbd1b91d876103035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29d378796b909ede67c6aedac411fc4bc533c57a72a292b84d9f863b8259f43c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cassowary"
  end

  test do
    system("#{bin}/cassowary", "run", "-u", "http://www.example.com", "-c", "10", "-n", "100", "--json-metrics")
    assert_match "\"base_url\":\"http://www.example.com\"", File.read("#{testpath}/out.json")

    assert_match version.to_s, shell_output("#{bin}/cassowary --version")
  end
end
