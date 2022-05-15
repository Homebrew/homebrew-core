class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.17.0.tar.gz"
  sha256 "656406f5c859ca669640a84672d185ecb1a864dcd1053da3122b26768d380a50"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eceb54636b218964145e15d878432843b506fc8d4f6ea5d427af6b6f6dfa8c6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c94dfc5efddd55a5a1ab1933a1e49e76437d1620e5fb3bb3df1c43885e337ec0"
    sha256 cellar: :any_skip_relocation, monterey:       "ed5ce7e33774fc9c3ea642b48935652691f56f8a98a308615dafc468d0265b21"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb2cd0c479bb3da6d7e3e9afa7b418d26be148a11a3a6271c25db0dbe1055e49"
    sha256 cellar: :any_skip_relocation, catalina:       "e317c84ab16572071ffe27a3e3d23b6728f7b4323cf17c9616b2c0246610d5fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f21ab9ff7909467f7d269edebb0a392579c6b6103ab2a3f89dfe6691c29bf55"
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
