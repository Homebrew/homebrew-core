class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "32b9107dfa12ac28560720509d44c0bc173e6092f5095a6b1a2787859ea2ce9b"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ad967d2fe34e5b9d82f50699d5fae1dc6ff5d9f8d5ea40bf69bf662b8a4439f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9a5ad443987d0831933719c7f78696538b24362b97601a964cf8defc10e0425"
    sha256 cellar: :any_skip_relocation, monterey:       "73d9c7450356807562aca01359f9e29c844cb9564d1ec4879bb90204794bcca3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcee78b80266183d13ab696e2a8dedfce71ee452fdbd4ad570c1ede86425d0f2"
    sha256 cellar: :any_skip_relocation, catalina:       "2dea79c5b9c23768129ff85df82c961b2c8eb93ab66c17fbf4ab694a46b27bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "832810ff4bd44b6edf4d631bd65c1d54e8997216a59280265bd76ba957fb3c94"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
