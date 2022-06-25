class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.20.2.tar.gz"
  sha256 "99e24355f5270f0c01f0daa1ca97679834d1ca04de8cedf5c01b452784e277f6"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c51e4df3650aab8ad49f892af2b652e3920468e82928a9c3f2884208c7bcdf89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcacd2629ce072d71771cd7f8738b0758d76eeb60fcb1d49cc8b4f974a586f17"
    sha256 cellar: :any_skip_relocation, monterey:       "a66bacd8cbc463c285ae3ab0cee3a2cdd564fae893cb9285a279669a4e4895e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b07db8aaa14235d0362eacc2a941ef995f821ce859db12a90857bb06628f270c"
    sha256 cellar: :any_skip_relocation, catalina:       "7f69cc06c12c4cd81140b0242ec62f71a048906d4dc0312996a88b3e6fec5dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdb6483ba039f052ec3d17511bfe06c556d4d22c9159e5c4e49a821d95ed93f5"
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
