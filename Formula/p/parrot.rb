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
    sha256 arm64_tahoe:    "df2fd855932ffb8d6ca5866f4e38864989636aa69133bc8108987f1bf52c02ca"
    sha256 arm64_sequoia:  "a51d427d1063c4e9a7bf13f9039a29fb6f9f690cfc751e6d100376435cd3c3ad"
    sha256 arm64_sonoma:   "33247f7453684d5af68220cb3aa6590adaeadeb6f4f45fe51e3e4584502e9b33"
    sha256 arm64_ventura:  "8d4542d74d3269cd5f1f8a096a8a6efb53b2300a22c1e0604c379da3499216b2"
    sha256 arm64_monterey: "91f7d2f17e362ea66be0f7706414a1241d5af6f8bce0c7054c1e0ef1ba39bad5"
    sha256 arm64_big_sur:  "d8a39b997791e6fc739322075c52ae288072b787d5f3f401b1040a6548649f63"
    sha256 sonoma:         "7ac793b0199ecfb12581ab18da0a014086c9c28cee8395ab6f200baa039c3aaf"
    sha256 ventura:        "e944d6d98ab02b17d2f563c434c85bdb72a9a2e831608c3f128ee155ebc15398"
    sha256 monterey:       "3790147bc1c0b294ef50417051b83abfe745149f4a102b8f0ba0ae25b8dea99f"
    sha256 big_sur:        "6953bdfac9ada389705bb8368d2223bb2e22640802a6e643446e018c16024e06"
    sha256 catalina:       "5ffc3252e0454d3d69689e8fa260011079d5684d568f5bb4a5d7d3f60368414f"
    sha256 arm64_linux:    "840cf36f41c1737e76b81b2964b844ea15554ce31d6e7513750facd69eff5d6b"
    sha256 x86_64_linux:   "26b301714008aa6c10ecd25b10d01bf361ed4772b90af0a9d50936d2108f9013"
  end

  # https://github.com/parrot/parrot/commit/f89a111c06ad0367817c52fda6ff5c24165c005b
  deprecate! date: "2025-01-09", because: :unmaintained

  uses_from_macos "perl" => :build
  uses_from_macos "zlib"

  conflicts_with "rakudo-star"

  resource "Pod::Parser" do
    on_system :linux, macos: :sonoma_or_newer do
      url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Parser-1.67.tar.gz"
      sha256 "5deccbf55d750ce65588cd211c1a03fa1ef3aaa15d1ac2b8d85383a42c1427ea"
    end
  end

  def install
    if OS.linux? || MacOS.version >= :sonoma
      ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"
      resource("Pod::Parser").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}/build_deps"
        system "make", "install"
      end
    end

    system "perl", "Configure.pl", "--prefix=#{prefix}",
                                   "--mandir=#{man}",
                                   "--debugging=0",
                                   "--cc=#{ENV.cc}"

    system "make"
    system "make", "install"
    # Don't install this file in HOMEBREW_PREFIX/lib
    rm_r(lib/"VERSION")
  end

  test do
    path = testpath/"test.pir"
    path.write <<~PARROT
      .sub _main
        .local int i
        i = 0
      loop:
        print i
        inc i
        if i < 10 goto loop
      .end
    PARROT

    assert_equal "0123456789", shell_output("#{bin}/parrot #{path}")
  end
end
