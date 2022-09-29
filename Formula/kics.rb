class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "676a7ef1d3d6144ed9b6e5f5f9ab95e19126fbbfa223f0cc89dc5a0475a83add"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe80317beb39e4e1668cb1b07b1368bb2c977a7f047456d876a9369dd0256bf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "921f151b776903a42c53c95cae11a2f326e68eb7c5df4190b639eb31e2db13ca"
    sha256 cellar: :any_skip_relocation, monterey:       "a0d620bc9d8e05cc2f2b03f65a791713b25e362b79da19d537acfb81b1500d9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "989182d3fa910e272a45abfb69208a6b22920bbba78a0c1d6b9f42228666a7f8"
    sha256 cellar: :any_skip_relocation, catalina:       "0d95dbae3653e77ccebf3d52d8c409eb10c6dfbcd686705ca27bbd495be584c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8581d7adc80c2dbb54bbe7b0aa3d9885f00cb137ec4d8eb5846a5e96f85d0e2d"
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
