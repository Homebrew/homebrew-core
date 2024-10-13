class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "759fab49724d7473b11e076fda932dd173558eb6c3287e8673b6a092f2103b66"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d1f224ffa23a73da67579e3cb36bdc07919929fc5ba778ef9868c15226d01386"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6090b9641a18431dcaf26570f65e328b1db78dec52a4655a0998b868823bd18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6090b9641a18431dcaf26570f65e328b1db78dec52a4655a0998b868823bd18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6090b9641a18431dcaf26570f65e328b1db78dec52a4655a0998b868823bd18"
    sha256 cellar: :any_skip_relocation, sonoma:         "710122515447f11124bdb6fac8249404dfe041aee981f66d8afa447513769fc8"
    sha256 cellar: :any_skip_relocation, ventura:        "710122515447f11124bdb6fac8249404dfe041aee981f66d8afa447513769fc8"
    sha256 cellar: :any_skip_relocation, monterey:       "710122515447f11124bdb6fac8249404dfe041aee981f66d8afa447513769fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c55deddb79df26d782bae15ded05b6b91943083a3122586b61c65d2104897f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", "completion")
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "Error: Failed to list store contents: operation error SSM", output

    assert_match version.to_s, shell_output("#{bin}/chamber version")
  end
end
