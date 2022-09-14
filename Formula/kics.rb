class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "8f2b3e65279bc292628e3b03b41d28ecbb0d1cc666143b901286633af64c0624"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ca4b4223a2f25aad642f90fc46d9e82b36ce595c47114279383e8b967d64a47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "557d0cf72b09bd8e7b54655f7a1abfa3007770e4df2fd6c6ec1e0378365f70cb"
    sha256 cellar: :any_skip_relocation, monterey:       "f559e37c776fd2dae22d9ad1f89560850874cc52a7ef96b0da4dfe4cb348eb03"
    sha256 cellar: :any_skip_relocation, big_sur:        "6db3d4f50d4672d65881d45b6486a27b5b42d9be0e25df4bad08ea4304647a3e"
    sha256 cellar: :any_skip_relocation, catalina:       "6ae2e9a059fb2871adb891292886243fcd16f9dfad32c9c0d675fed73917c8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b254291e17614a85e8c36e616b07f84fea93dad3c1053d42afbcfd64f458afd0"
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
