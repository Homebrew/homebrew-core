class CqlProxy < Formula
  desc "DataStax cql-proxy enables Cassandra apps to use Astra DB without code changes"
  homepage "https://github.com/datastax/cql-proxy"
  url "https://github.com/datastax/cql-proxy/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "25cd9a87078c11caed7da14d2b8b85e5240bfe1aff5b666d0dcad9e73c15b305"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c40edbb5b8f950de21ac5ab40e99e4e4c3dffa5f854907ae8be3b97b453bcb8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c79d8cdd3f900c4096c5e9acf193dd7d03b17eb3713d514772e314d1b35b231"
    sha256 cellar: :any_skip_relocation, monterey:       "4234a8f0300765647a7bf841efdda05fe83d42a6f46ff0fe95df85e10a03259b"
    sha256 cellar: :any_skip_relocation, big_sur:        "636a68d6a6a45db32ead9cf6dfb8d0e6e2cdc3909be8ff675fd55db875432a73"
    sha256 cellar: :any_skip_relocation, catalina:       "bf932c54fd666e1d902672a5bf69a021a3479b2326766b9521079c9457b139f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cc1203816a51f1a3322145f36a9aae27d82def0a32d8883c859c1da94aeb966"
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
