class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.20.0.tar.gz"
  sha256 "ed35f324522021fc5c6122c9319552245f26e34a19029e87169f194113d2f864"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14146c9d7bfef782294b92c9265f7eeeaa6e2241ba65e4bf0e86798573c367b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f7787a54b615e89eeee6e411df31249bbad81151c5ab60bc79cc1e61e31de66"
    sha256 cellar: :any_skip_relocation, monterey:       "37b78e43b66547828be4871aa9b3aa8d8cb2352f1f4d397d12a01e09db1894cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "622430f69e2bb031a9c0ff9b49ba5f066455ba7b1eb65e8059ca64da004bd61d"
    sha256 cellar: :any_skip_relocation, catalina:       "5fcfb9bb6d1f4894ac2b8d8bb46663fbe67bab0745f1494a6d5c0f16e2823e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ca4e898229d0db6591c897ff197c1568f080d198a398c4255f47e44ec92a846"
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
