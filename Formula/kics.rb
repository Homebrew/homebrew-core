class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "af1e0f8ed86238647c693b4d5c5272b20b916328676585301f6915a7c9932ac2"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c8bf57d396ff5eb26975be7a5a21f743401ef604ba0691de1c94cb496c649d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e38abd58868ecddac95f646e4865ed00db3e28610f6993ce938eba89fbf422ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9d4ab1301b0a5d2ee3d3c83502451a2f0190754446cd8b22675a05729d76cd5"
    sha256 cellar: :any_skip_relocation, monterey:       "4aadc4397523e48c90e43b6b179be7f8cf976e5e5406759964e5e5aeff8e333f"
    sha256 cellar: :any_skip_relocation, big_sur:        "05a8de6ceee502bafeef3aee2a4c8774ce8a3d0d39bdae75e8eac4993c38c681"
    sha256 cellar: :any_skip_relocation, catalina:       "363fa052b0d3db597918df47fd7a655a80771808987f387286c6406af531801a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c39694b60efd4be757c3d20919c8d3cf402f09dfedd4836094f73b723ffdf99c"
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
