class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.19.tar.gz"
  sha256 "9996054a715a8f614f33491e8c61e99b28758e9ea8273da2ce4962d7c5cf0b46"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c536cc4739127d369897eb6f04b3eada4718680474b0f8ca065e79a6858f6aa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43b057ae5dba48a73bff322c3e9d7171748d42616130740d82032a7344f7fc10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45340b8bdc03e7e68fb9b784f577457ef623583e1fe10cc22de8d045e210d370"
    sha256 cellar: :any_skip_relocation, sonoma:        "d51a12dc27980b64d44f0064121b8d75f9b01b77dfa5d9c41cc8e2be35fb5599"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0a832e64716f012e4d67c12bd4de5d0a1e13bec5e85e4036dc5a51855620424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565113143a0e9650558e8ed7387312da4e7d8f9157b8e23d23313a5c2551c484"
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
