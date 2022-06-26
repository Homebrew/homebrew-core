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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9afd2b5105dd46a489fd06510689461728c1f39717db8a0dcfa9df673739aafb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d6ca5307dc87de438f33933855d21f132ea20af37578e935692561555ce4f9a"
    sha256 cellar: :any_skip_relocation, monterey:       "cb235a66bf26b2488277988902822039e40325555708b333315ddeac169fbe84"
    sha256 cellar: :any_skip_relocation, big_sur:        "87d669fa25a49911927d17d3fb9176907b434a2ddd10c7c093d11662cb4ec943"
    sha256 cellar: :any_skip_relocation, catalina:       "274fcf2837dfc2ce6a86b6d635dde16ca950d9e5f5959f85b267e7da0a5ec7e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "731d604db538852b2f525c9c0ad520d527982152251cb24b8f4c7fe282c8dfb2"
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
