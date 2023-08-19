class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/24.1.0.tar.gz"
  sha256 "1e034ac1d815b05a06a193fa409da1bcbf35453a04759e2c76c745a82da1ad87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "185c41dd3aa6e0ad357eaad273f5d86c0dea4d99912c5bb09a62d80d03e72500"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "185c41dd3aa6e0ad357eaad273f5d86c0dea4d99912c5bb09a62d80d03e72500"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "185c41dd3aa6e0ad357eaad273f5d86c0dea4d99912c5bb09a62d80d03e72500"
    sha256 cellar: :any_skip_relocation, ventura:        "9cfc19dc2064867f758d799dbbb1e25e0b505fab21ef445a986c45fa43fdfed9"
    sha256 cellar: :any_skip_relocation, monterey:       "9cfc19dc2064867f758d799dbbb1e25e0b505fab21ef445a986c45fa43fdfed9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cfc19dc2064867f758d799dbbb1e25e0b505fab21ef445a986c45fa43fdfed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee39619c0637ae0e2978c90490b95271e4ba238c34c909f399859cc9c141a8e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output(bin/"fx", 42).strip
  end
end
