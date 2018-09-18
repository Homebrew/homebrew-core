class CorkscrewRs < Formula
  desc "The quick and dirty port of corkscrew in rust"
  homepage "https://github.com/rustch/corkscrew-rs"
  url "https://github.com/rustch/corkscrew-rs/releases/download/0.1.0/corkscrew-rs.apple_x86_64.tar.bz2"
  version "0.1.0"
  sha256 "47ad58bf7dc4e521223865b6db83f0de77be2dcc0ffc2801a1e0273edc31085e"
  def install
    bin.install "corkscrew-rs"
  end
  test do
    stdin.write("#{bin}/corkscrew-rs")
    stdin.close
    assert_true stdin.read.start_with? "corkscrew-rs #{version}"
  end
end
