class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "86f821409fd34a54475b3905f3bd6b7e5ec1aaa04f5bdbf9531ca7ee9e0ea70a"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f4471f143a0fce36f41af3cde68af8da2adc00ebaf3f56f85112888fab40dba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9328bcf79433ff55318efe15007b8e1752732b5300c7e8430ba235a32951e63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2d6ff90adcf7671d5174ec0be6ca4c72639ece1cdfbb689ff5e76b9515ba802"
    sha256 cellar: :any_skip_relocation, ventura:        "def2c4acc2e31d4c56c7fecff2d83696a214a1ce44af34e5aaa80f90cd1ecd8f"
    sha256 cellar: :any_skip_relocation, monterey:       "735b5e9c1f49a3a3bfb290a242559b1cfea2bdbe3d7a8b2aeb186e1edbe633b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a61a300fafeb1467f46300e91556523f0b84402cba7de1f8311b11419bd5526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f304640df7a32246bcd1f9362cb0b0bde0d1a01de24618b10df7576bc423f5"
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
