class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.5.14.tar.gz"
  sha256 "add406312b8f611a0d8b68b06ae0b105d78af13d10172be70e40f41b66ebb1a6"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c3e2bdd7d91a548a47556a2b40a0125c650576633304d9eaf164b0e0dfd6b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5e3b90f9abea44b49d2bbce25477ed0074fdf46779ec80cbf1b4a335d9beb42"
    sha256 cellar: :any_skip_relocation, monterey:       "34c1a187dd7945242cd69731faa73dbf87e14bae97852fd8f8f697a7d43d04bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b3dec04a4061361b84024bf1c04b14e8a42db7381a5193ac3b4c9fa860fafe6"
    sha256 cellar: :any_skip_relocation, catalina:       "b0c66db7e921c993f9d3c6bf641c7d97dec6eb584b0099f1d4512ac0a9b93c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cf1ea858d7521ca78d08e9b2155d3eb623f27174b97b8cdc2ac691c447dae67"
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

    assert_match "No files were scanned", shell_output("#{bin}/kics scan -p #{testpath}")
    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
