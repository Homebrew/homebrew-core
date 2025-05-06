class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "1598e29d32de41e43c498ec21ecd676d7951672b787314303d6e9adad4e4614d"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f5bc8940ed8eab35678a45cfab172290ba167a44846b8f0dcc12eb99a6ce16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1551e9cfa03e62f8250cb8d738a0f61f78db2467c2fbab4d546a1d8e319f3b54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3999744d59ff3700ae6280bbdab8e67d4b202d52cc3e4ce7fa6470894bf01f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e163c6758cdddec2c1722dcf09a03bcff2c826b7e3c6965c9914885508b6101"
    sha256 cellar: :any_skip_relocation, ventura:       "c031f2af1f874e8f86497638d5b9f630283e78b116b5db79359350ddb0749630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7feaf70aaac4f6a8e37a85f46f622493b550ae6fc77c86af936209412fc97ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ea8b65d0899c8436dbaf0187a757f9c438442cd7d781a3e8331e98b6f61472e"
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
