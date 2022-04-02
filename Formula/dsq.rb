class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.12.0.tar.gz"
  sha256 "a5d4b7e2476f298dff9114ddcb12258e8863a540a1e72a9df22eda8d7d31f5d8"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1a6e70620f8362a6c7dfd94c5b2db8bda9526c1f74d619448b21b6f691df6a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e2dba4a3722d8bd215da0527c4cb2bc27da7dde53b8e1ec9b76729633fb4806"
    sha256 cellar: :any_skip_relocation, monterey:       "db13c808fdd1eeca8de5df7410f6022d03b8d922725cdbac02eb9c383d87999b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ecfa8eb58b49ae75398f947c413915a6d7c2c755de7bbd244fa29209d712c96"
    sha256 cellar: :any_skip_relocation, catalina:       "16feba3c4a1b9833427122d5fa52879cf011022b95b792f125a980e5523f3d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f591dbd361ed32b9cffd2bed92e139fe3199d78d178551fdf7e1e032177d4f2a"
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
