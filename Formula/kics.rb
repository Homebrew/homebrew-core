class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "751ca33ca3c66a30e45de998989006a099c5322ac75150828cac3f421171c5a1"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e9a65baabb806d8c0e65763405a833bf2c75b1fd91f6d3ead3cec9e77658ab6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e3eb132cb1817f885c14bff360ffecdba9b0ac0f875cb2a6e28e05a0b3798cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8bb9a89adda9750b16ff5844d30e3e9a87142502c96f19d3a31ed9e4ff1520b"
    sha256 cellar: :any_skip_relocation, ventura:        "60137a31c2c638a7f55ef3dbccd1d594a9f1d526aa13fecc29fd3a416f8d4ee8"
    sha256 cellar: :any_skip_relocation, monterey:       "0027bb3e322ae4d4a7f9081d5cc18b78129ea62c5c7b95c4732785de473e3cfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b8a796fc36fe8dfeb97e4a5c1d0feafefcf78bab085c61a7bd4e3cddbf8adc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9fbe9fd8c16cc720044d2d83c1ba894c133c998cf9569b19ea08f229dbd6cdb"
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
