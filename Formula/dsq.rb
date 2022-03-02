class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.5.0.tar.gz"
  sha256 "bc28ecb1cc78c9446d67d9ec3e4333691802adcf3bbfd430ba3c548c5415af40"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d2cad78261156a231f8c26cb7814874b7553fb4834ff567bcf5eab4aef47c19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63f5370867b5434bb4999178d91d9dde5c511af648d3c0e7e86099768d871ae6"
    sha256 cellar: :any_skip_relocation, monterey:       "8d8da11a22f687fe433838c37e793d63666142fb032b18536706b1422b5fffe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fd9604f9b7b92fa81921333bcf2b812953b605342d4baeb0167de25dde7893b"
    sha256 cellar: :any_skip_relocation, catalina:       "0af7e7ad3ccac1f3eccd5a6cde2a1a3eb1c33b8faa2088e9354b6f002bdc6cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91cbb897fa8b97fec977b75082e438c2b0ee87d8be706a8912c4ae378f1d6439"
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
