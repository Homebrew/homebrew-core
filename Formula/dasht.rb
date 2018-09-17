class Dasht < Formula
  desc "Search API docs offline, in your terminal or browser"
  homepage "https://sunaku.github.io/dasht"
  url "https://github.com/sunaku/dasht/archive/v2.2.0.tar.gz"
  sha256 "ba3e20b351c0c0b4bd526d306c577e104414656a9ac011d672cb46892d394030"

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
    system "#{bin}/dasht"
  end
end
