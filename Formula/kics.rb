class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.5.11.tar.gz"
  sha256 "2b3eca85e53046728b730aa731954bd3cddf932efd136753a1046ef5db3e46c5"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0057b36d85630441717fa83e20af4a01ee376711996f1b3cb075c720a8814fca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6c5ff574ad691475084d90b2fccf8144ffe14e829d8527e3427f072667bf506"
    sha256 cellar: :any_skip_relocation, monterey:       "d774c50b674f6f6b2783a8ed0180d205a61f6be9cbb76a8bb2cd535cf7477333"
    sha256 cellar: :any_skip_relocation, big_sur:        "70ad80442d5da9f38a04081817a3239640860abfade3b7e859e00c03db148d4a"
    sha256 cellar: :any_skip_relocation, catalina:       "55fbd613e3b19a9f848e77992f09eebfd143ecc2fcae6bfd19d03c4228a84026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f126d26a76c25c6287462690cca92d6ebc56c7c6c085307f192eb5a1827770f4"
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
