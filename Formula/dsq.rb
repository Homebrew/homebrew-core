class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.15.1.tar.gz"
  sha256 "e8d24d3f231c712a042d1f090ff19a50c8fecafe5a7bd896dacf824aa0dd5b28"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca89ef4c7b94f553077d86d58a91477cb6f29cb48974e75b4a61ab6e39c73af1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79d88312f6e8957fc977c9c3ccadae16d749f0178f17f70edf90c28e64a36c58"
    sha256 cellar: :any_skip_relocation, monterey:       "28cef56f8c44911fa4513a6974963844b6dfaee1113f6a563458a4e52914e749"
    sha256 cellar: :any_skip_relocation, big_sur:        "4adf6f77e7c1faf940630f732071c79faf1e312f8b6a6c11b32629208b71e5b7"
    sha256 cellar: :any_skip_relocation, catalina:       "6384a067b189a1de403c13b39431cc9140ab04cb3932da4ba3c48bfcfd56ca34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c2ae124fec624d4ffc5c4d72fac63f7554e299e8489a67372c7ca067c9cbac4"
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
