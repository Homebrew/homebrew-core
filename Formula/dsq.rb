class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "53f3de7e1af0fcdbde0ebe765d736d2cdb2e7848314a5916813b9e35523a0825"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "732fd7172290873d737a4836b038864241da83575315e503b32edb39135de9ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9eae773da09bec36776d0f03318cf9343c1874919951f4fc6eb8c65b220bb09c"
    sha256 cellar: :any_skip_relocation, monterey:       "9cb8ef9bb608c3ef51525cde188183f0bbb303a757958ca62944885f2dca325d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3ba067c67b609f11896d5de810bd98cb376d7c251f33457a016a75b113cc93b"
    sha256 cellar: :any_skip_relocation, catalina:       "0abed0687bbf108fb34fe342f5d573dfeb1ab54456f3f5e1f734242a99fb43be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a8e608439e930392ae9e122e8d1f157531b4a74749e241abbde64bc385b76d9"
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
