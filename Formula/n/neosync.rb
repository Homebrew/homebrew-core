class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.67.tar.gz"
  sha256 "f2a54c0ae0b3ad5d8b8fe77a0397dca97299c72a9e31a67eaea0f7044983dbd3"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb76d6c4858611ebad683f53aa0beb3c6ead1f5915b0fa79a4d404cfda92d565"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76a2624e54811a376b4250a6b8abfc4225639014380752a2244886f3c038a6b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f02072f0736fd8094148bccf6ecd5f2b0e375806eb2bf256b21d8c7be880509"
    sha256 cellar: :any_skip_relocation, sonoma:         "f659b867fbad7fbd5f944b08135a76dacda86f34fa40455af16316d132b90ec3"
    sha256 cellar: :any_skip_relocation, ventura:        "b1ee331a83c733f37a7fe34384fe1e8ed03b5b4a6e3ffb3843b767e12aa3983a"
    sha256 cellar: :any_skip_relocation, monterey:       "f7d033b3850434a6d7d8ef3307770774decd8035ac1504923ec20ffa8e089c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beaabea876532a5bb4f8b49816ab40f760ed2767a26436157b862878a27e3466"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
