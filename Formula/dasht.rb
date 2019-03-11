class Dasht < Formula
  desc "Search API docs offline, in your terminal or browser"
  homepage "https://sunaku.github.io/dasht"
  url "https://github.com/sunaku/dasht/archive/v2.3.0.tar.gz"
  sha256 "44db949eb95653e59d88eafce2b2d1e4378db66776e0d39ee15453dabf010e09"

  bottle :unneeded

  depends_on "socat"
  depends_on "sqlite"
  depends_on "w3m"
  depends_on "wget"

  def install
    bin.install Dir["bin/*"]
    man.install "man/man1"
  end

  test do
    system "#{bin}/dasht-docsets-install", "--force", "bash"
    assert_equal "Bash\n", shell_output("#{bin}/dasht-docsets")
  end
end
