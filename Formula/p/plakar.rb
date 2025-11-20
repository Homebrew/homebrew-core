class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "403062192081f65aaab598ec1837a6c52a0cf3ca22d4c77c658d83be5edb66b0"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28ce10ed9474bcc0a78b73e05090999fe5d87fc5064540df2716510b42b456b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc727cd39a1196ef0ace1783fb7aea21419549b9e849a8d5978672f9ac16c25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849455f36a2031332508f9b260553ba9e44e180a7d0b9d521beccdccec2bc14e"
    sha256 cellar: :any_skip_relocation, sonoma:        "acc28eacd552939fb0e1dc68d036f3d152d32404c0ee33a844b77d649b856bc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86f6af7a42ef77eea9a6224a9070bde3113d224e7c8f1978fb5f82a5a938b3b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10229b28cf56bc0c4719a69723322183e9be5657728867f05ee521451dbc5854"
  end

  depends_on "go" => :build

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
