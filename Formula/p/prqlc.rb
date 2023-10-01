class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.9.5.tar.gz"
  sha256 "641846a1f1f2bdb5120f83880c1027b7868401f22479b885b972ecf0437296da"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29d6cec61d0ff700296377bdbe1db65c8aa8ce2beba5bd419b641543d98a28db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65b7c8e7bb16c9d04ffef9bda7bd6fe7c42692d837a7d79980be0a562536c546"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6fb488807cf21cbd5bd5015cf5c643caee07de5aef4334da322a08b59132042"
    sha256 cellar: :any_skip_relocation, ventura:        "361431bfc3ab656fcf7bc75727bee4636ec2ff95a3f8f7ea4bda07cae93e6ca6"
    sha256 cellar: :any_skip_relocation, monterey:       "f8d243af656237f5a1c4a7d7225b1786b551d3e2256a2ae2e05a37ba1a1d0271"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba51e11a1a7039c3ad5a74ff7c19f275da27edb28657c7c91b1f9d06fb771ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cf54744596340136cd708c86ef81eb4b63f36a184e57879ecba31add4961b4a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "crates/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
