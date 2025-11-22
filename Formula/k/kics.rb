class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.16.tar.gz"
  sha256 "2be592a16eebcf19e80d7006e0d1b456c5e143003c27cd132783bf437880dc28"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17536a58284559e0bdaf523946cf08b269795dd593a92dcabf45ca6dca6c3ef4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b25e393251d2372f2b54530e45640b0af4802d9ce0966dee1c51a360508acd61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84692dd0d7c231c8937bf89957869ec3833d2b7b8f7dd50e71bf296a61337123"
    sha256 cellar: :any_skip_relocation, sonoma:        "780e86eb74301b8db0252025ed659057ab4c9fc1170236fc9019589e733c127b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ef0976d7bc11567fc09c0ee10b57deb02422b43f2a346ba3e4ab7fd4b27cef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be989596d8a1c3f759767a4cf52f7362377ffa38a082b78665de2d450193b5d"
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
