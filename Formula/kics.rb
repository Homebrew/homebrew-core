class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "73626d28ca4b0e602fb8ffb188cdfe1191c1c85158b1ee114fd4b0231e806848"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3fa4ae7a2bd2cd926cbac7989bd667a904188c07144e908802b66eba54ee9e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "876c5627e4c23715bf8515a52b89ab1368994d81507bdd500bbd94afc9fb9694"
    sha256 cellar: :any_skip_relocation, monterey:       "faf2862801b127cc62fdbde0d31354fd2e33d791b34cd6e2ed1746b9c49e4e9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6d07c25c9c7906e27968905f16d89c469c6694070d1f5a3dc9777c746efcf6e"
    sha256 cellar: :any_skip_relocation, catalina:       "8e6c1c3e5b930058d461f124d57dfdf9057cf70083cb32d4a3c231c205ac0040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fb34a1302282d859900785a02023c615873c616e1659f32ff67e086e3286173"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Checkmarx/kics/internal/constants.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/console"

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

    assert_match "Files scanned: 0", shell_output("#{bin}/kics scan -p #{testpath}")
    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
