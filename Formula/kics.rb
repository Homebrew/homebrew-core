class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.5.15.tar.gz"
  sha256 "596c1dc39e6ad29b0a8f93593ce8a20fed1ac3ca0506a1e0646995568d0f156d"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed60bec8dddd6620fa64590dcec000affc9fafacca514faba73dc3d97b509511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "104e939d3223e446c7622aceb30404b05586a58b49909c180c0b0473070280d5"
    sha256 cellar: :any_skip_relocation, monterey:       "79a5c07b3b37a23f6118ff20d4cabc32c513ac4b4d1fe82d3042daeed75b3c68"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd4763871c3ce743d2bf17ec2f85101e1d837424a9a139082136b6720f1e1c97"
    sha256 cellar: :any_skip_relocation, catalina:       "51f91424d49f12055bd40d734927950dcaca95877798365427c2e0eac3aab2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "566b054122dcc7cb8b0f047efac9e5cba83fe7f640c9596d9635ae7170539f42"
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
