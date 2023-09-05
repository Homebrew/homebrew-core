class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "a809facd1cfb398807987e27b80985436c6b16ef0681ee1e8f91dd9cc8b68ef6"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d891bfa2204d7e008f4120041f257ea9ecd13453beb4fb1b3c778ce8a6b89bfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3623d4a2ef6dfa8a10f3962e40507a1c81eb42a60d2778c00266b58d9d766374"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41ce55828a45def485036f72b4c9d433983c809cd5ccf4c3e17bf65e552b302c"
    sha256 cellar: :any_skip_relocation, ventura:        "99cc282da28b59f6c2f6282242974ce982d5277f9e1a28a9a597374a57b346fa"
    sha256 cellar: :any_skip_relocation, monterey:       "53f35274dcb6c85813c6948fd3bf8629b0d75d3e8363f5b6dcf6b57edf1a59d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8f51ab3fc98e1eae304b7f7b9a3972d5974745512d88ad3df6d72e840d6ad6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2976a1676184071d8ecb95fc13707ee1d69066af84b123ba74863fef47573afc"
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
