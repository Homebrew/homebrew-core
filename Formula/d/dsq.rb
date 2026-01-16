class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "02c923f9089399bf66809bedcb3fec27022f11829e0ed2ac9c7ff87f72e85d8d"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fa7e3bd34ceaec3f64e14bebd8f9e69427d5641f06c0b68e2c6ee092e72658c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b0d6ada6a0a2844f2d0a007d2772b07f7409ca98db78299f4b27de2f6a19a44d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8352d31efe2ed49a6d2e0ddec2bad500e468deb5a9fc883d16d5103d2607569f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eaf172ab4d1aecede0ecfd67bc1faeeb7925d3e7494889ccb91f3b1aa0127cc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13453e55035ec7f611bf1497d34c7e0eefae9e74a85bc2cd97b88ac158e93ac3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63fe0d51ed81cbfe1b078d92c30ab1c643107ab77239941b1fcda4fee473167e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b1b842984c0eab5b0fb999556be8789a058b0274a4033c988fe83b414e7b67a"
    sha256 cellar: :any_skip_relocation, ventura:        "cb66853afae665e55d8fe3fac0c9cfcfcf32136390928a62a1c6f4138b226145"
    sha256 cellar: :any_skip_relocation, monterey:       "1378c8a63d25c81803072c3ae5092e9abb3edd3ac5dd56f51409671f1ff3b8b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f18c7a77e60d4c6ffebab006f5eacb751c8a0ffa729f506b153e837c03f59934"
    sha256 cellar: :any_skip_relocation, catalina:       "4733972637d9dd70139520cf2dfd0b243fcd3a8bd62b455efc144dd8bcd1c895"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b5627ad8b74b97db053faec48c4bfb41f483aad98a70265efcf0b3fcda3b4b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "328ba290cbe117afa004b3ac9c9ea32fad38b062150ba47de467ba409ebd0069"
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
