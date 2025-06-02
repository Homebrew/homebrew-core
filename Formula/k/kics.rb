class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.9.tar.gz"
  sha256 "cc6c293f301a240902cf1e9aeca28f2ef54e0848f579ef7a447c9a60f4f9a69e"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4621550de72bc2e5809aa25dd0d8b2a37973e9a8aae78747ea4b7d874fc4726b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8335b9c44dbb41013b26611d9bfe70b5755dfdf07a4c5beec86453dcc39d8936"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8892d7c657aa2e995b4e9e9ed57f358cf4efe399ab3a32edc6d51f56862b25e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a2d5bcf1f13aae73c2d8078a78a2015b20518743fbc203e13b4a1415db34e74"
    sha256 cellar: :any_skip_relocation, ventura:       "6df39e9b389471481da0f1c61672a39eaca1e187912047f1a821b5c72232b187"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72fb41d5afd4483ef0a58ff84a4858b25d8bdc498c81e66c424d530ea64c1a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da6ff5346f9e7c243d25ee04897780b9756f7ca3815e8c6c45f7e981f624d1ea"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Checkmarx/kics/v#{version.major}/internal/constants.Version=#{version}"
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
