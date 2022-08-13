class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.3.tar.gz"
  sha256 "ba898331d76e266ae3af4e5eab5c6af30ef004c133104fec3e0bbb9497f5c70a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18b4dcd42ef0bc7989c1af5911222c6d4fa384cf13ee61fe921fe20194f2bb5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1185e18a6366501b6b119f83c6fc2b9bcbd1f4ecddbfee6b2ade8d726ed1e94a"
    sha256 cellar: :any_skip_relocation, monterey:       "285f4609c57b43a55a865c58406c64344fda956294ed5cdb931bc0e2152678e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6f062665c9fc48804f0ffc81c1dba42b6b730449cf9970eab148a3df6d196ad"
    sha256 cellar: :any_skip_relocation, catalina:       "6a09ec495c10bfe74472265497c6b6495d4ea06c099c66f674d124fffdf43ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9338f3cfeaa02b6886b04d769f9436af7a2d1f30b0c70ff6f5d295de4fe472fb"
  end

  depends_on "go" => :build

  # Requires less 576 or later for --use-color
  uses_from_macos "less", since: :monterey

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
