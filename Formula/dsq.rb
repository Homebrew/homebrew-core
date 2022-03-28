class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.10.0.tar.gz"
  sha256 "a5cd99c32d5ffa63736aa272455a0a5172e1820f9275f053e2de80fcae7a67e1"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8917324fbc8299af1de439e41d78dbadcc72b008b6471967a059f41b9b556125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a1a2a53fa8e6657dc2b516885ca9d2d8677ba7b80f82d197ab642daa1fb39d2"
    sha256 cellar: :any_skip_relocation, monterey:       "f8b7bc968e9af1b085dfc373a1d12283a42168b4446d7035ff1ef82771d0aad7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8efea9084de49e8f6c2f3ee0b4e2f5e3390b22e8857519c68d5f1a6c00738294"
    sha256 cellar: :any_skip_relocation, catalina:       "ecd046b46d312f2058cad7b90b03ea11091bf4690a61dfc9a1c269905c8c07dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fb0a0edfc4d8e2502c4bf1f7b1901dcf4f55a555cbe4ba23cf18f7a9fe55241"
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
