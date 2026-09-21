class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "3be94ee0b393699b72f00be8603260c60d5531c61aada740cfcbbc3009d1ef05"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f0efb8715db85fc1e0080d8629eca1205be8402c1d8f9a78617ec1c7e45f08e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bfc6ab278b38aa2b09ed4b17834cc7b623e44409a474efe59f9b29a1d10592e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36d69892b1eea2e02f0d6114c95ea62dce81b5f77c8f2b37d7af8fa2836ff0b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b56ebf35ca15a80e41ec1295d6b04f48e15952781de6a8fe94d79d35b9d5f554"
    sha256 cellar: :any,                 x86_64_linux:      "54a40dda251f86fe884ed44cc082fb190d4661b046a0d8df9f9cdba4a141043b"
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
