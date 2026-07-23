class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://github.com/foxglove/foxglove-cli/archive/refs/tags/v1.0.32.tar.gz"
  sha256 "4855f94bcb9e399aec99111dea90626abbf77cbfa70d86be9e285f530e3f3220"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d27595ea78ce880eb52768ca86d560df877d615206f50c97b119fb5522a9ca13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bf7f1bf23f216a5bb4e6dbb9f2c876ec1f866c4798d1bf7e5b7d0cfb73f97f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10829281d54c977cf7e002fe6de9238b90553d5abc15a51409a07304c3a7f5ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dd0a6ca0a7d689fbb1fdf96f6c634b1943e5958ff4294a7286afad2440a59da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fa92b6f350d865a9d627c1e5b50404186d5805d66a9557cfcee894bb988cab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d22d8c169b489f5e4670e3ef115b77ef8efabef025479d9b5af3845b8f211eae"
  end

  depends_on "go" => :build

  def install
    cd "foxglove" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "foxglove"
    end
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end
