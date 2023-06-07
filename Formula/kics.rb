class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "89c1c93912c3a3a12a7d2ddf4473e8dced9b517fdf397b419c53c929217eab96"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ed11990c034b3298e37b405cc49bdce0531817431fe6cdc3dbf1c093882f7be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4963a51a3b9561fc007e8fd6d6f732d919fe734ce2a989e2413a9d7fedbf0e9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fca48e83fbf92a06e46660482b17180bec0dcd663254009cb7ba7f769a6260d9"
    sha256 cellar: :any_skip_relocation, ventura:        "9879f9536cb4185df86542c338acbdd7ebc48de503d51b2fa34de0346c5e8a6a"
    sha256 cellar: :any_skip_relocation, monterey:       "4d00fa7cfc53813c9ac627e74859fe266ce102b200150ffe7318abbd6919dd2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f65a92752d20741ed1aa43590c942c679e262f63edbe3b9a9a71d32e64ff9ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0f9b3ae979350021781b94dc6b01b4eaf030262beee1bf2a580c4f3725f404"
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
