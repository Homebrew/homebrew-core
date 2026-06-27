class CqlProxy < Formula
  desc "DataStax cql-proxy enables Cassandra apps to use Astra DB without code changes"
  homepage "https://github.com/datastax/cql-proxy"
  url "https://github.com/datastax/cql-proxy/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "9c08158674244b297c3019f0c755e84742d8824f380f185e035419a2de539d77"
  license "Apache-2.0"
  head "https://github.com/datastax/cql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03f84d5e2eb848b641075a1e2b2298a8a7755cc06a4cad38abcb57d9d64dbe6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bb3a1b8bf92e37379d4765635babee8424e20556d77448c7ddf8527879ca08e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bb3a1b8bf92e37379d4765635babee8424e20556d77448c7ddf8527879ca08e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bb3a1b8bf92e37379d4765635babee8424e20556d77448c7ddf8527879ca08e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dbc0fb6ba197d0580cad3327f8d6f10a4a3425fc9aa93a96043e45932a969a7"
    sha256 cellar: :any_skip_relocation, ventura:       "3dbc0fb6ba197d0580cad3327f8d6f10a4a3425fc9aa93a96043e45932a969a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c66d460a5288fdc86c5316e917e2041da66e9a240cd7496706dfff88ac9d4f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5329be03e21ee3e5a58454aca78a6a08034b955efce86e2e2d14caff0e101b3"
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
