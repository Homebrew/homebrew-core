class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://krew.dev"
  url "https://github.com/kubernetes-sigs/krew/releases/download/v0.3.2/krew.tar.gz"
  sha256 "643d2936d00766e198a3748d2ea3f002177a3747f9fe476923c7e0002ab662f1"

  def install
    bin.install "krew-darwin_amd64" => "krew"
  end

  test do
    system "#{bin}/krew", "version"
  end
end
