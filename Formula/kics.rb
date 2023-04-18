class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.14.tar.gz"
  sha256 "fc7cc5f13ca55f42e60bca9718b3bdf86a14c60827eb181cda865d5871207173"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32acab2ee5d9d4f2bb84659afc2f75daa4dfa91e18769b1c61dce6ab92b4a7dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e2658fb08b4dd5691d7d28ced135eb09a08af026ed696946d06ffb174a34be5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75e0dbc5efe9b6be0f00fab83e4e300b633c4e02846472206f6921e0af9d1405"
    sha256 cellar: :any_skip_relocation, ventura:        "b19dfd76eb62787841b3fb75547e5c597485946bfbfba53a97804d606042d385"
    sha256 cellar: :any_skip_relocation, monterey:       "6f4bed92738e5993f9ffb19f14dacd5493de78f98ee301bcf693a65eb895e641"
    sha256 cellar: :any_skip_relocation, big_sur:        "69643d370eb06b9cae56fc3e62cc0ab43b7bc909029faf779db9823acf905fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a979eb763b42de5302ed06f62b7da8bad7bc82468ab966040cbbd9e0ba19249"
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

    assert_match "Files scanned: 0", shell_output("#{bin}/kics scan -p #{testpath}")
    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
