class Parrot < Formula
  desc "Open source virtual machine (for Perl6, et al.)"
  homepage "http://www.parrot.org/"
  license "Artistic-2.0"
  head "https://github.com/parrot/parrot.git", branch: "master"

  stable do
    url "http://ftp.parrot.org/releases/supported/8.1.0/parrot-8.1.0.tar.bz2"
    mirror "https://ftp.osuosl.org/pub/parrot/releases/supported/8.1.0/parrot-8.1.0.tar.bz2"
    sha256 "caf356acab64f4ea50595a846808e81d0be8ada8267afbbeb66ddb3c93cb81d3"

    # remove at 8.2.0, already in HEAD
    patch do
      url "https://github.com/parrot/parrot/commit/7524bf5384ddebbb3ba06a040f8acf972aa0a3ba.patch?full_index=1"
      sha256 "1357090247b856416b23792a2859ae4860ed1336b05dddc1ee00793b6dc3d78a"
    end

    # remove at 8.2.0, already in HEAD
    patch do
      url "https://github.com/parrot/parrot/commit/854aec65d6de8eaf5282995ab92100a2446f0cde.patch?full_index=1"
      sha256 "4e068c3a9243f350a3e862991a1042a06a03a625361f9f01cc445a31df906c6e"
    end
  end

  bottle do
    sha256 arm64_monterey: "91f7d2f17e362ea66be0f7706414a1241d5af6f8bce0c7054c1e0ef1ba39bad5"
    sha256 arm64_big_sur:  "d8a39b997791e6fc739322075c52ae288072b787d5f3f401b1040a6548649f63"
    sha256 monterey:       "3790147bc1c0b294ef50417051b83abfe745149f4a102b8f0ba0ae25b8dea99f"
    sha256 big_sur:        "6953bdfac9ada389705bb8368d2223bb2e22640802a6e643446e018c16024e06"
    sha256 catalina:       "5ffc3252e0454d3d69689e8fa260011079d5684d568f5bb4a5d7d3f60368414f"
    sha256 mojave:         "91a463baca8872dbd12183a61326c78c8ac0e05a01bd1a0421578cb0f6e58427"
    sha256 high_sierra:    "c3ce1d1fe24e6f5172629cd092cc03db16b957649865af052ee6a72d75fa10e6"
    sha256 sierra:         "e8c50fee6a2111412b5f6ac31292f3ff7d3e4dd2be9a02cc94a890026588ae63"
    sha256 el_capitan:     "3b78be029276ca642cb2bc705888ed0cd7745c0398cf90bf67031190191c76a8"
    sha256 yosemite:       "37a9ad2396bcf355d6d7ae2d432489e316d3290528947a6f1a30e753fed59902"
  end

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl", "--prefix=#{prefix}",
                                   "--mandir=#{man}",
                                   "--debugging=0",
                                   "--cc=#{ENV.cc}"

    system "make"
    system "make", "install"
    # Don't install this file in HOMEBREW_PREFIX/lib
    rm_rf lib/"VERSION"
  end

  test do
    path = testpath/"test.pir"
    path.write <<~EOS
      .sub _main
        .local int i
        i = 0
      loop:
        print i
        inc i
        if i < 10 goto loop
      .end
    EOS

    out = `#{bin}/parrot #{path}`
    assert_equal "0123456789", out
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
