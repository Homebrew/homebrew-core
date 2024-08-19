class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "5bafe86977253f7aaa62d8893fe968142bd0a1a7746a9f50b689c8cb2c9fb4d1"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "733769ac2f214e6eceb57f9370871524087de3718b9ad928b5c77adc9a8910a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21dbc0d36da6216569790e087b0dc370be6cacc8d71e9b3f883e8e44df1f5e52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "821ae283c0763f6d42497325d14625f1f925e5c8b112c772782e120f6f74a134"
    sha256 cellar: :any_skip_relocation, sonoma:         "680ed568459af0ae0f7c4d2e55e034d175ed0139ce51a1ebcc13cf31a4f77806"
    sha256 cellar: :any_skip_relocation, ventura:        "5dfb57156ebda70d50e7721d58ee69fab1fc3042887fb9ff43803b8dcc32f96d"
    sha256 cellar: :any_skip_relocation, monterey:       "86d7b685afe04fd66614d0649118a9197b3337be37ee94bd13b912c757eda914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c15476141b4344fff16e1b334a59cd3fd778ece18eca168411f9cce8a6197f9"
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
