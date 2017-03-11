class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop/archive/v0.4.1.tar.gz"
  sha256 "bc10b774dad0bc7ef0be41bcfb36c774fc28dafa789b2f43f1ecdb5b75390867"

  depends_on 'go'
  bottle :unneeded

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bcicen").mkpath
    ln_s buildpath, buildpath/"src/github.com/bcicen/ctop"
    system "go", "build", "-o", "ctop"
    bin.install "ctop"
  end

  test do
    system "#{bin}/ctop", "version"
  end
end
