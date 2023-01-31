class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "86f821409fd34a54475b3905f3bd6b7e5ec1aaa04f5bdbf9531ca7ee9e0ea70a"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5d975b35c4560206485be4f0561b488e24f4e5fa0999fd57416d7ff1dc132cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "112e0b19ce22332e4f6f2c8d5f6f3838a8b168dc6f732bceeab6304dd1419045"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abc89e634fe2154b27636dc51c04d0275b00e86e261fe78b4b5a8984a096a15c"
    sha256 cellar: :any_skip_relocation, ventura:        "6e25fb448fb42176f04be19e47ec6044a79e93ba8593ae6e3a19f5002bae877b"
    sha256 cellar: :any_skip_relocation, monterey:       "29bd71d02e8735cb08e6a7d3a3d4599f3457002c13e7b7d4e16bf3b32f9c93de"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b30fe3e09c12e9e8c0b1e9719f65227b06090898e60ae6b09bb78af9a06d83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "811e3fefc774685ad708223f16bc07268101be2a181d194a1ba333c1e1fca622"
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
