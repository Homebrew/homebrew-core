class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "7163b06fdae0b6c4646ab2926b99527fd293231271551c743445fbebfb4d24f0"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61701a1e5736440b8bc66a0a42049a54697e1605b7d41b8c051c1316ef69345c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f809aecdad99cbd7b1aeebd74509cad3c1211e68914daeb2308b28c04a01445"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75b812ac2d430c98d192c19398a3545ea308aba9bcd39dda4a94a1954261be15"
    sha256 cellar: :any_skip_relocation, ventura:        "f70135dd2962fff9feb8c92c30c274fee0c8fd168187f2cfa91fd8b6d8ef4fa3"
    sha256 cellar: :any_skip_relocation, monterey:       "18e261871adf38bbee2b60c19280d502ab10c37a1b01cf2171ba9a2e9cf3698b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a4f7d81774102638acc708d7a6ad1eb4ae010060b8d6529f679ecf7437e817c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e960bc0d172b1b3887dac34f391e99582449d1b07a394cb565b8a5c3dde877c2"
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
