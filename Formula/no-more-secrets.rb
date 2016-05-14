class NoMoreSecrets < Formula
  desc "Recreates the SETEC ASTRONOMY effect from 'Sneakers'"
  homepage "https://github.com/bartobri/no-more-secrets"
  url "https://github.com/bartobri/no-more-secrets/archive/v0.1.0.tar.gz"
  sha256 "9e42f359bda578716d176245d416b5924ed0b321390a28221467301bc10e537b"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd05137d5e6612beaef95b5baefa0390bff9b9bfcc2ccdac08936d0f1662623f" => :el_capitan
    sha256 "c5bfc8f8213fad1b9f31e9d12bfc5d235fb00a8880dd29e7159a496508d794e7" => :yosemite
    sha256 "b1efac63c0fafcecc0f2c7ef04820f50e00d99b2e0a8fe46ed889b8042803b6f" => :mavericks
  end

  def install
    system "make", "all"
    bin.install "bin/nms", "bin/sneakers"
  end

  test do
    # nms is an interactive-only program, so we can't do a real test
    assert (bin/"nms").executable?
  end
end
