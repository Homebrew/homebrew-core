class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "15c8825f9f0b2e33ce22e8061a60c6a0948d58acb7693b25b4b99702d01f5c1e"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf8a571422c9280f2f52826df6156fed5bc0193f4572ff44e2c8129e2c9d87ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a22f7d280a301f6c54e23fd7f64d0acd938fa97e809c6af6abfabe651a6ed0e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fcc5d19cab92991b82481a14658990dc90fa8605ba3863c0c67992a216e3bc5"
    sha256 cellar: :any_skip_relocation, ventura:        "faf6033488f5364b426965d7768c5d1190fbc55067296e6e4beb322cab3b4d6c"
    sha256 cellar: :any_skip_relocation, monterey:       "a9bead04e30bdfcbfab8bacdeba91cfc850fef964e2cf60857cfbe6f4375dc8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "81b4fd065edd7d08f2734480f8af1fc8fedbee1d098fd9d9f53cbdbc95e08077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a752e1bc1bfcc6f6d989cbf3bcc2bfbdc202d04ac31175203171cb911a7819"
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
