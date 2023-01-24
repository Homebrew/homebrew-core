class CqlProxy < Formula
  desc "DataStax cql-proxy enables Cassandra apps to use Astra DB without code changes"
  homepage "https://github.com/datastax/cql-proxy"
  url "https://github.com/datastax/cql-proxy/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "fa2dbae0622d1a4d04db54db4fb6ef0a1857eaea5a300a5145c529ccb4b17d66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fa9cf794a088910b19eb5f796907e0a7890cc4f041f1eeaf0e1919ea16f12b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c70df3d91138d2b9a45ace13e9dc06183d3706277923a7b9aa148ba10633d1ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39fda7fc2620dfe85c51c6ae4e4a610ff8dc8a1c14fb54cdec5dd5404e5ba0e5"
    sha256 cellar: :any_skip_relocation, ventura:        "5b8fea7b9a7dacf1a4084c810eed265a38b035cb721c60a45a33d0fbaf36d1da"
    sha256 cellar: :any_skip_relocation, monterey:       "c11803b4600192258ddf4404cf67d9f922e34b490cd6e4a80d430826b0beded6"
    sha256 cellar: :any_skip_relocation, big_sur:        "67986132bd8266cd944bcce9001c1673633f9d4781b6f51cb5d4d582617d8358"
    sha256 cellar: :any_skip_relocation, catalina:       "c27fbf050c448cfd5e4b95832701f9c12f540bad3b4aac424d49c33b2e8cf32e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "372e5a3a6f903bcf11cffa51d4841e0806f7b4dfb7d1ed29439d97decc0814b2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    touch "secure.txt"
    output = shell_output("#{bin}/cql-proxy -b secure.txt --bind 127.0.0.1 2>&1", 2)
    assert_match "unable to open", output
  end
end
