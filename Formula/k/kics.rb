class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "ffbbb7d7ec2a9933da6575e31c39ab4884b3cdec7de98fc8a3bc1f74d55537a8"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef94b12565eca7630d7e68ccc13477c835ac3b80b0c21cf8f76da4b4f6106456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddcdabf458606a05267fa0853b6cbd4b5086696119de632f6b5f0086fc2a7de5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5449c7093db56c69c2eea48c8310c703868f1879db54763f29ea7668fa6165c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4313965930b8072d2d6af8c8a7165d4bb1b553b1bc1565d65c76d16cf66420c9"
    sha256 cellar: :any_skip_relocation, ventura:       "9502d3a1badede424f1b3db3d4af65f75102cb289f6ddc9eab8d150534e9ee4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "010ca0f5121e76325b09767a659947b38071bdc05505d3e03bb58e4636be9d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e0f5ab235d15212fe0eaee1b180aa8c8fcc666e454372ea75d83cc0a7226af1"
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
