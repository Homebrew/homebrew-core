class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.12.0.tar.gz"
  sha256 "a5d4b7e2476f298dff9114ddcb12258e8863a540a1e72a9df22eda8d7d31f5d8"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a894dbb3afd874f0fa726ec0e264b6b12c7805f47a18fdc00acabceb30a5929b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9d858190dddf16841622b51f652eedd4c8f03946db4fd7737a7b8e92c2521ba"
    sha256 cellar: :any_skip_relocation, monterey:       "37e45b0a9807c2c3a025c3e1f898f11e42239f481d7d3291ff8fb1a81fe8e159"
    sha256 cellar: :any_skip_relocation, big_sur:        "885cde0689d240621e5924c16efd822a608ad2f9d5486c917dd7bd5c924e4955"
    sha256 cellar: :any_skip_relocation, catalina:       "384b1bcbf1f4032a681978b6b4222ef679fbaa398af42c3ce2315ef54c69f6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28be96ea95b70abe7e72affcbf3871b2f7883620003fa2e263cd391714da44e8"
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
