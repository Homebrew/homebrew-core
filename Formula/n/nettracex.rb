class Nettracex < Formula
  desc "A comprehensive network diagnostic toolkit built with Go, featuring a beautiful terminal user interface"
  homepage "https://github.com/nettracex"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nettracex/nettracex-tui/releases/download/cross-platform/nettracex-v0.1.0-darwin-arm64"
      sha256 "efde7f944a65de5925af970ee39c8cd36f30c7c3ace0a920bdefd873d0595820"
    else
      url "https://github.com/nettracex/nettracex-tui/releases/download/cross-platform/nettracex-v0.1.0-darwin-amd64"
      sha256 "59ea9e9d9430760fbbbf4a0685c04c01429e74abc75f6548fec0375aab57375d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nettracex/nettracex-tui/releases/download/cross-platform/nettracex-v0.1.0-linux-arm64"
      sha256 "d3b6d64de1b2fbd9e8bb2bb91caf8a7082f1b51310376a671d2c05a60ef7f5ee"
    else
      url "https://github.com/nettracex/nettracex-tui/releases/download/cross-platform/nettracex-v0.1.0-linux-amd64"
      sha256 "ea10eea4cb691d6e2caab0663e274267246f8520beecee97030b45977f1e5597"
    end
  end

  def install
    bin.install Dir["nettracex*"].first => "nettracex"
  end

  test do
    assert_predicate bin/"nettracex", :exist?
    assert_predicate bin/"nettracex", :executable?
  end
end
