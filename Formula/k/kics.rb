class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "ccb3412d65938e1445d7ef225bd3275c6f9bf7e356b5ce3514f80c8ebac3ccc0"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c5d418b593e494bb9d30ba971ee3f586060e8d443a72d836d54577876c88ddd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd1e58c1111e248d62d9223cb4efa13d9ed025c98e3c06eca150bc7e04a19bd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5ad0e5eac5d387dde99bf18c030f4e73adc62b75f58a499b8dd16edcc9b8f3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1095ac11f3246d95c3e11529c1fe4aa4610477486a27130d8b8af838b0a01237"
    sha256 cellar: :any_skip_relocation, ventura:       "8b28ecc7321009145023eb10906e4360ddb2d99a75e0dc5560892297973a0b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11460fbf1e83ef1e419851359e241ac347abb6bdedc5f837bdf7b29165748afd"
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
