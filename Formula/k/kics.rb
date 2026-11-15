class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "df72535798cb79671d570c41e95bfd6b38e30f893850e67c8c522b94ebb61cbe"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72ac0272cb75f9d41efebf788e4669e9eefa96dbd558115ccbf0e88aba47d63c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e297e7433bfc7884d47d2bb846cdfc2b9f5c5d819b72f44a20d7890dc4984bd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5eb9df859657c878011e0a27239dd704878a5fe9902275c092c86c39001043d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb2f93870c4d2dd3fa6efb7791de7a6c67b315e795d22473eb9ef32292dda939"
    sha256 cellar: :any,                 x86_64_linux:      "95e4a977449d8ca2d81912fe80fdc75563753a700f05c0402a04bb1542a0fc64"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/Checkmarx/kics/v#{version.major}/internal/constants.Version=#{version}"
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
