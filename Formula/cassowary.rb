class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "1f10e23af218d661e8493e111d425da0ef6f4408d845a473fdbaf45dd6e2d94d"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51cc4994f99f679935450d266d095b3181a6ea881ed3557ba8de708666dca0cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35468f258ee836f1aea6b6e6bdf540fb50ae475c1af3e5d164fc9058088ddd7d"
    sha256 cellar: :any_skip_relocation, monterey:       "0d2b43d7d17e11efdab072de93497b89ed93416cf2682c3c721ef77d2aa8b778"
    sha256 cellar: :any_skip_relocation, big_sur:        "26959efc426320546612ddefe82338fae95639304e5bdd881285e0ca1c947ef5"
    sha256 cellar: :any_skip_relocation, catalina:       "bc565d13bc8df0a15533bb64db4c545e7b532304d9b6cb997363858f2253dda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d321b0a788a95f9f955a6ce212c4a025248cbfb8a1793232062d132e852c0a"
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
