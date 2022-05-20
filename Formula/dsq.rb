class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.17.0.tar.gz"
  sha256 "656406f5c859ca669640a84672d185ecb1a864dcd1053da3122b26768d380a50"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9d7f0a20913c262b758bf740d4d10e21fa3a9379553990cb218d57f4108bc8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30a25c6cd8f923c7d4230c832bc67306426289a931942ee3d23c5cb04c7778e5"
    sha256 cellar: :any_skip_relocation, monterey:       "cf4f211e9a9d5adce991a4c8d7f30900d29f4a6d11eed7e1f73e54ea7ddf39b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fb6199f1590132781767d876650bf7bb1cd40cfbf011a99b78c2ebd7ce38e60"
    sha256 cellar: :any_skip_relocation, catalina:       "25dbdb5f6dc9c94226ca229c4c0ddbfd758e6aa3d3236e40752470beff166998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76cd5d34c9f51efd7b0153667c48119e7317abbf86426d23d1ace71a23c8499a"
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
