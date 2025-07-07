class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.236.tar.gz"
  sha256 "9e0bcdbccd573f3e42a5c007ea509fb58d96eb129307c407d493ef681fb63466"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404a598a1e6d87513f42fd4b13f76cde3415ef3e4f04f8cba7581d08376ff0f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "404a598a1e6d87513f42fd4b13f76cde3415ef3e4f04f8cba7581d08376ff0f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "404a598a1e6d87513f42fd4b13f76cde3415ef3e4f04f8cba7581d08376ff0f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "defef3d791b0112a8d1681c3bbd8dcc4e87a3b0c6d7d6644aa721972d43a0a54"
    sha256 cellar: :any_skip_relocation, ventura:       "defef3d791b0112a8d1681c3bbd8dcc4e87a3b0c6d7d6644aa721972d43a0a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bceeddc9d4972a27efee47940b0292ec16d295fe7661db26b54228ab8f8f3f11"
  end

  depends_on "go" => :build
  depends_on "yt-dlp" => :runtime

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
