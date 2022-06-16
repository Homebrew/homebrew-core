class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.20.0.tar.gz"
  sha256 "ed35f324522021fc5c6122c9319552245f26e34a19029e87169f194113d2f864"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21b083246b6326fda39157894eee5a74c20d0f7ed1b1fbdcd720350f215ed541"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "091c521c0e59e4ecfdf3ce7e7c7dc36ed79bd493d34303554ae699d79e5c4a54"
    sha256 cellar: :any_skip_relocation, monterey:       "91e7a47f984d01be3eea27583d7fc556971c0fe86a786455fe2656f22ad80add"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d3409c9b57e460230cfcfeb77533963c3806affd0c6a40a85a301812723bcb8"
    sha256 cellar: :any_skip_relocation, catalina:       "b0e9d644e0383824cf22b3cd9fc22c302cabf2877975f121bd678b487f093a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1c503abf0491d4bbc176fb171a837218c8a9d893f56b81e42e5c9f0d1d95887"
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
