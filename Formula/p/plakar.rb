class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "5f9af49e9957b2fc659f0c9192db748785c95a1319290e69469df971fe3eeb9e"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "054379a5d933068e2b4cb8f48fc11769a05ec55f5cc798520266046948bbee35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f34a5a006de72588b106a09723fb32c3c321681652072687799cfae22ccce3cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd24298b97a6640cfe6c9b903e0a0764f79495cb7bc0b59e149a57b2690e44e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4ded53b51adcfce38ee43603aaa60d7cc9222e26f18ca0ece5a69dbc5927346"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a75c2526701fa560eb4af9eb9f49ee348a10591a2de1827b19c82efe6986532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58e4bd7f403dc08a91f22db461e9e3647aeb5fde6c269d096bad97a5eca34f71"
  end

  depends_on "go" => :build

  # bump cockroachdb/swiss for Go 1.26 support, upstream pr ref, https://github.com/PlakarKorp/plakar/pull/1845
  patch do
    url "https://github.com/PlakarKorp/plakar/commit/79c5ce3cf30822010e395d33078b6abc6a0b992a.patch?full_index=1"
    sha256 "37df26982c016c3eefb1103db63622cffe65a8b79e114a3c5201b236276317fc"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    system bin/"plakar", "-no-agent", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo
    assert_match "Repository", shell_output("#{bin}/plakar -no-agent at #{repo} info")
  end
end
