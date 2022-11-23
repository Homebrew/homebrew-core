class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "af1e0f8ed86238647c693b4d5c5272b20b916328676585301f6915a7c9932ac2"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7521f7ebb5f361d36fa465d54ee620fcc2d31dbb85ad038b763064b15b1c833c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af1ec4913c819c444d7017ac5896b6e5ba00201c8e8f7424069e2e181cbf20db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef7a148eefa7770fd68996b6bf1fcdcb1d1ea505e8b289cf2964bf68961c99b2"
    sha256 cellar: :any_skip_relocation, monterey:       "8c8e4911b9bcdbdd765e23de3786b934c7b62e9b32f1acb88615fc05513095f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "183d4b8fdd9b072328bd15a334c17954ef93476acbe632fd5311e0caba32a373"
    sha256 cellar: :any_skip_relocation, catalina:       "a0e1a94c8e90a82c9d591f2c470e590415502477cfdb76ffdc9a14026f00b46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f067a8a641cba22587346220bfbd5aa5bda6d1ac321a58bebb075cdac1b34a41"
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
