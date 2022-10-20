class CqlProxy < Formula
  desc "DataStax cql-proxy enables Cassandra apps to use Astra DB without code changes"
  homepage "https://github.com/datastax/cql-proxy"
  url "https://github.com/datastax/cql-proxy/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "961c002d9cdc12d78c37f35775e8a18f42f96657681894dd9e7edcb22e546c37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c70df3d91138d2b9a45ace13e9dc06183d3706277923a7b9aa148ba10633d1ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39fda7fc2620dfe85c51c6ae4e4a610ff8dc8a1c14fb54cdec5dd5404e5ba0e5"
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
    output = shell_output("#{bin}/cql-proxy -b secure.txt --bind 127.0.0.1 2>&1", 1)
    assert_match "unable to open", output
  end
end
