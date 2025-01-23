class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "7914ab3fee9a162e02004df61da54dbbd8a452275117c60397ab148ca5197b76"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "715114d5318a40d965ab10d8877106eafedfaf23b552e31afc8d0c33d3687f3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caa5e7c1689374bd365165567d1d17e4f7cb8f8882d458fd8ecf78120eb2b321"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f59abd9072d3745ccf077b70163290ebfdcc4411a4819c8de73ad07eac35b47"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a9c2a61b42099cf59301f0c0910f26131289563c2dbb95afb0c0790b6642750"
    sha256 cellar: :any_skip_relocation, ventura:       "a9c40ef16f720523b3fb24af9b4decfde9905c9d093040f8cab663cc01d6d806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5d6f18f4902ae0feb441938f7947f8df5278a1c6bd6fe4c1b790870c5b8b740"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Checkmarx/kics/v#{version.major}/internal/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/console"

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
    ENV["NO_COLOR"] = "1"

    assert_match <<~EOS, shell_output("#{bin}/kics scan -p #{testpath}")
      Results Summary:
      CRITICAL: 0
      HIGH: 0
      MEDIUM: 0
      LOW: 0
      INFO: 0
      TOTAL: 0
    EOS

    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
