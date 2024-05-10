class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "7c4b5c5e2d696db4edf5a319aad39c8108156c2832fbf2c4429c92c6ee2ada2f"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bc80fcbb1692b139e56e373286324fc920f0f9ca6582e05a66f8ffebeb939d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d3acbf525a4655cf4621c635eec41ab14fb17aa8e714ad1984e17fb25d4a355"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a8fd1e9a5bb5f35832b75f719e0dd536d227dc2f5bec09bc0ae3a2943f24ff2"
    sha256 cellar: :any_skip_relocation, sonoma:         "272050530665cf1ae1885f21db1cdbbdd2463bb509107394747c336740b50609"
    sha256 cellar: :any_skip_relocation, ventura:        "604d7850eb94c17cc1c168bfd7a01d8751040298774efae66e4ba46d768807b7"
    sha256 cellar: :any_skip_relocation, monterey:       "8175af214421abf85237de91097f5825f0020dcf9bbc0a589639ca7a86ea4e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0b3c6f3c28197841fa26d69e89f76316072a60561c607d84db2bd832dcd585d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Checkmarx/kics/internal/constants.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/console"

    pkgshare.install "assets"
  end

  def caveats
    <<~EOS
      KICS queries are placed under #{opt_pkgshare}/assets/queries
      To use KICS default queries add KICS_QUERIES_PATH env to your ~/.zshrc or ~/.zprofile:
          "echo 'export KICS_QUERIES_PATH=#{opt_pkgshare}/assets/queries' >> ~/.zshrc"
      usage of CLI flag --queries-path takes precedence.
    EOS
  end

  test do
    ENV["KICS_QUERIES_PATH"] = pkgshare/"assets/queries"
    ENV["DISABLE_CRASH_REPORT"] = "0"
    ENV["NO_COLOR"] = "1"

    assert_match <<~EOS, shell_output("#{bin}/kics scan -p #{testpath}")
      Results Summary:
      CRITICAL: 0
      HIGH: 0
      MEDIUM: 0
      LOW: 0
      INFO: 0
      TOTAL: 0
    EOS

    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
