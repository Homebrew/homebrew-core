class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "8b4b3c466421215625889943ee2bf63c8646790782d47876516ea12fb1b46a0d"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "455189a5a66a22a280fccfa5637342c8bdd58ce88ec989bbacbaec47563b6d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "811a7e6456710fba3e77a301b3d73cbdeb571350fa01cd39a6ff8635f87706eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92440cff93c7da89ffc27ad7fc24cc746b2e422759ef79ad98c2cfa66c4290cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "560590ee9f89362065186e3a0fc7cad37ad410e80020256389732296a9fe9b05"
    sha256 cellar: :any_skip_relocation, ventura:        "fcd5db5b39ce128741854d0021c32c2777871716f04ddb88e09b5bad311aeedf"
    sha256 cellar: :any_skip_relocation, monterey:       "8500138af992e39dc55dd7f78463142cba3cd4996fd5d02f39f94a87581e5bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b157bd9cf51909456ce61fb3522aa989b325a78c41715811b300fa0d04043964"
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
