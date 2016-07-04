class Dasht < Formula
  desc "Search API docs offline, in your terminal or browser"
  homepage "https://sunaku.github.io/dasht"
  url "https://github.com/sunaku/dasht/archive/v2.1.0.tar.gz"
  sha256 "98b4c130e64a33fdb9559d8c9d85ba1526236ccdb311b805f28f0128b167555e"

  bottle :unneeded

  depends_on "sqlite"
  depends_on "socat"
  depends_on "wget"
  depends_on "w3m"

  def install
    bin.install Dir["bin/*"]
    man.install "man/man1"
  end

  test do
    system "#{bin}/dasht"
  end
end
