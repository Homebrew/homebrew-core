class NoMoreSecrets < Formula
  desc 'Recreates the SETEC ASTRONOMY effect from "Sneakers"'
  homepage "https://github.com/bartobri/no-more-secrets"
  url "https://github.com/bartobri/no-more-secrets/archive/v0.1.0.tar.gz"
  sha256 "9e42f359bda578716d176245d416b5924ed0b321390a28221467301bc10e537b"

  def install
    system "make", "all"
    bin.install "bin/nms", "bin/sneakers"
  end

  test do
    # nms is an interactive-only program, so we can't do a real test
    assert (bin/"nms").executable?
  end
end
