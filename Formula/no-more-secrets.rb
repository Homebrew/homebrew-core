class NoMoreSecrets < Formula
  desc "Recreates the SETEC ASTRONOMY effect from 'Sneakers'"
  homepage "https://github.com/bartobri/no-more-secrets"
  url "https://github.com/bartobri/no-more-secrets/archive/v0.2.0.tar.gz"
  sha256 "cc0f588d1c05290027c7b33d4639e9a860122eba1af9475c00db9d3b18ffdcb3"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd05137d5e6612beaef95b5baefa0390bff9b9bfcc2ccdac08936d0f1662623f" => :el_capitan
    sha256 "c5bfc8f8213fad1b9f31e9d12bfc5d235fb00a8880dd29e7159a496508d794e7" => :yosemite
    sha256 "b1efac63c0fafcecc0f2c7ef04820f50e00d99b2e0a8fe46ed889b8042803b6f" => :mavericks
  end

  # upstream commit that fixes version for 0.2.0
  patch do
    url "https://github.com/bartobri/no-more-secrets/commit/e07eddae.patch"
    sha256 "20dce9db7b7164f5529a94dca71c9f21195477980dae7bb8c082eef5d942f911"
  end

  def install
    # ld: library not found for -lncursesw
    # Reported 4 Jul 2016: https://github.com/bartobri/no-more-secrets/issues/24
    inreplace "Makefile", "LDLIBS = -lncursesw", "LDLIBS = -lncurses"

    system "make", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_equal "nms version #{version}", shell_output("#{bin}/nms -v").chomp
  end
end
