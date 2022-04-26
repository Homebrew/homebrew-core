class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.16.0.tar.gz"
  sha256 "d8feb5a1fc195a30e6a6f5648d9ec678dbd51fb792197797819642b2b1c31453"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbc58d7bf943a324de1c7700a9038778b699b3edf37d5fc3505fb5928fadbabc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "673ffa9135aa017ee90afedd5642e9ab0b79cf1df1c8109d65eb9b0a782b0d27"
    sha256 cellar: :any_skip_relocation, monterey:       "98ba74df5668474ddee24d72f770282a9128c98442f19a4cec4f03133b3f23fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "484d71ca3c89ad4a5bc6fb98c6c89f2de3dccaf30e07722a468145e10c3660e2"
    sha256 cellar: :any_skip_relocation, catalina:       "350bdf52e897be15ab5a17e467e2337a2f3201730492f51407cdc171725f3b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a299b9ce15db8762d8e15bca26b322bcca8f909ee55210b3af8db7103bfeec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    pkgshare.install "testdata/userdata.json"
  end

  test do
    query = "\"SELECT count(*) as c FROM {} WHERE State = 'Maryland'\""
    output = shell_output("#{bin}/dsq #{pkgshare}/userdata.json #{query}")
    assert_match "[{\"c\":19}]", output
  end
end
