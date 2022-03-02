class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.5.0.tar.gz"
  sha256 "bc28ecb1cc78c9446d67d9ec3e4333691802adcf3bbfd430ba3c548c5415af40"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a453d2fe435d588377ba5caebfb6fcf60eb6e2dcdd3016f45786c35f6f40a4ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6232475dda8537344f33309e712581465958655e4a0ba09871639b2c1051e68c"
    sha256 cellar: :any_skip_relocation, monterey:       "ea20e82619f64c3c3fa683328d9bb659e13a6343b49919435fa212f4e97dc50d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cda8bf41579a837505067aaa94a3ac8c2e2a146f693b5e0e62c6c7b741c704bb"
    sha256 cellar: :any_skip_relocation, catalina:       "a07dd2fa8049305e3aa612652457ce55dbaae700a3c4bff8c75775d709f1c017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7ef72c8b77d2872f898b0bc63ee1f8b207688327c212547ebf68da00ef7be78"
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
