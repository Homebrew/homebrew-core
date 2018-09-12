class Parrot < Formula
  desc "Open source virtual machine (for Perl6, et al.)"
  homepage "http://www.parrot.org/"
  head "https://github.com/parrot/parrot.git"

  stable do
    url "http://ftp.parrot.org/releases/supported/8.1.0/parrot-8.1.0.tar.bz2"
    sha256 "caf356acab64f4ea50595a846808e81d0be8ada8267afbbeb66ddb3c93cb81d3"

    # remove at 8.2.0, already in HEAD
    patch do
      url "https://github.com/parrot/parrot/commit/7524bf5384ddebbb3ba06a040f8acf972aa0a3ba.diff?full_index=1"
      sha256 "55b6cae8b48e1f942c7be83955250b0a6d3b1132539b42cee532c9b2b6952b0a"
    end

    # remove at 8.2.0, already in HEAD
    patch do
      url "https://github.com/parrot/parrot/commit/854aec65d6de8eaf5282995ab92100a2446f0cde.diff?full_index=1"
      sha256 "3452227cfdf4827ef26d0d9d09db5528c20fbbc19a95f76fb4356b19cfb88e88"
    end
  end

  bottle do
    sha256 "91a463baca8872dbd12183a61326c78c8ac0e05a01bd1a0421578cb0f6e58427" => :mojave
    sha256 "c3ce1d1fe24e6f5172629cd092cc03db16b957649865af052ee6a72d75fa10e6" => :high_sierra
    sha256 "e8c50fee6a2111412b5f6ac31292f3ff7d3e4dd2be9a02cc94a890026588ae63" => :sierra
    sha256 "3b78be029276ca642cb2bc705888ed0cd7745c0398cf90bf67031190191c76a8" => :el_capitan
    sha256 "37a9ad2396bcf355d6d7ae2d432489e316d3290528947a6f1a30e753fed59902" => :yosemite
    sha256 "ff4125f633f43c19134e2520c0964025f4ea14efd5ce826d0cd905c550fbb24a" => :mavericks
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
