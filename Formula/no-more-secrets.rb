class NoMoreSecrets < Formula
  desc "Recreates the SETEC ASTRONOMY effect from 'Sneakers'"
  homepage "https://github.com/bartobri/no-more-secrets"
  url "https://github.com/bartobri/no-more-secrets/archive/v0.2.0.tar.gz"
  sha256 "cc0f588d1c05290027c7b33d4639e9a860122eba1af9475c00db9d3b18ffdcb3"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b4c4af8d3475fc8288541878ef4261317155fd898a45add6a99ed7f704f873e" => :el_capitan
    sha256 "9043f555a3586cb6f9e6d14cb2ee6af8e10510e6946f80bb6d8799ca914492d2" => :yosemite
    sha256 "e6969faff5484a728a6b339b4c6448e4b801313253c4eea874d8f705f8f3b6fe" => :mavericks
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
