class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.5.9.tar.gz"
  sha256 "d5573e2ba63272cb32221043e0df54c49a4bdb218bd62745ca08d2a8e705d689"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adcdd6d54494437a064600c6914a469cd0a4a2f4986cbfb6d156f1d8c631a3f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b469f5bd3fc8b296b295db3a43d648f940b9302a35f9fabab1bfea85b49318a"
    sha256 cellar: :any_skip_relocation, monterey:       "e738e43f4aa51067a683cf86ba47098ebf230903c833f50d05595d0059d5b17d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d128fa00e5317e4192c6ac27f3c59bbc1deaceab5d4dc2fcff140b2e1b455d79"
    sha256 cellar: :any_skip_relocation, catalina:       "e7a11d878d4b25ee5d2724def4baac32a2bf55869ef451835b41a5fcce7e354f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0af1a60c4eed61561f82bf44892cf80ec6c7f024cba4ebde02070e35829fc3a9"
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
