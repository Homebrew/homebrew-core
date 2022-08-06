class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.5.13.tar.gz"
  sha256 "0d95b132459b1658d2d547f89385c26dcd32d7546e3c8c97a953a362db795c63"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62ca8ce784a30bf457b937068671ee664f9fc6533904b8b1ac03e48f684e6964"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07f6ec5db45c5f97e1c7581596980130b70eb1290b090daaf3c881617fdfc534"
    sha256 cellar: :any_skip_relocation, monterey:       "aa6c3f6d5199c9713e8e24a462664329e9573ea538ede7e590177be63ee551a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a88d88c348e7c9ba5fd30359d61536c48c7ee69792e82e79bdb0983ff8455086"
    sha256 cellar: :any_skip_relocation, catalina:       "1be1d82015962a8eccdcc08c169caac8f80b949e391556c1fdec64c374e70b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aaf3cf8c3ebab246e03f841a3fc9bee16018643fe6025dfbb835243717380de"
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
