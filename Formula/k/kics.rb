class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "097072c07616ab4dbcaedb91e8b1591da20fa599323c1b56657cf4e677d6dfa3"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07475eab11615612e97fba016cb12f80e3c8dfc5bc28a691637695f4146e8f90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ca6495b544ddb5cc0bc1a9cd16d5e8015d5a6dcbcf48d9e74020d19c722153f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43d2794598edf5da3873606462d22c10be04c6bb146cf2bddf33a49378defe08"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1efbd44d7c612e791f4d0d1b38df5592333c55091f468b304defa8e5fe582f8"
    sha256 cellar: :any_skip_relocation, ventura:        "e5efbb5b6511399f94ebc1571ec2e69c670b1da1ef07e018d553c070ee2a2806"
    sha256 cellar: :any_skip_relocation, monterey:       "64bafc6234bfa44361e6a7a97347e65802368a196e3682b0f355f1af907d7589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffc298ee5699de4d9cd08a161a26c6ad49bce4fdbb0850184616488eabc9e63f"
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
