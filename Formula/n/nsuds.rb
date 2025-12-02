class Nsuds < Formula
  desc "Ncurses Sudoku system"
  homepage "https://nsuds.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nsuds/nsuds/nsuds-0.7B/nsuds-0.7B.tar.gz"
  sha256 "6d9b3e53f3cf45e9aa29f742f6a3f7bc83a1290099a62d9b8ba421879076926e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/nsuds[._-]v?(\d+(?:\.\d+)+[A-Z]?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "6a85cd2409e3f89ef8578b377b849b1c04ebe32fded4bee64e5ce1961ad1440c"
    sha256 arm64_sequoia:  "bd292cf994f5641b70cfd91b592bc8e82b9a9895d1c95c718ff0530a9b98668d"
    sha256 arm64_sonoma:   "2a478277a19b9cfaf40f2b675cef9113b6db1d662468fdaf2e34c7d9200b5cb9"
    sha256 arm64_ventura:  "3971aacb07fdd707ad1365f0a7b8b27ab1e694cec0aadac8b117d16639baf75d"
    sha256 arm64_monterey: "711432e1f5a30ba46ddd772ed79b173a0091abbeb96792d10f25180ab2a763d2"
    sha256 arm64_big_sur:  "983aff6a207bb1a4224ca713567000ccb578b108d6c358982654e2fcd59313d9"
    sha256 sonoma:         "919378da9a48cb758e0e3e4fcd6abe39e81e04c369a77c868b33fbd78387408a"
    sha256 ventura:        "f83642d920b2f5b8c053bf29acbcc582215568a0a646e5797f7026daa099342d"
    sha256 monterey:       "2a9d8df67a2c0b7689a48960487bc7f240db19f321f492448c30608de7f59c2d"
    sha256 big_sur:        "17ff896355ee4f8905783422f8e1dbb68b88d45ba1ca6cc46116c93ec35bc2ef"
    sha256 catalina:       "dcccae0ffd504a9a09ed57bfe0ac26127723c92513177eb862fa132e21c6968a"
    sha256 arm64_linux:    "e38b08c1f769caeeca6deaca0f3a1c0d22364ad89f38973edd6dd3edc6bfc5b0"
    sha256 x86_64_linux:   "bebff61d5efe0ebc66d905824e0316e2c2f46b0c48128855478271de5abb9bb0"
  end

  head do
    url "https://git.code.sf.net/p/nsuds/code.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `showmarks'; nsuds-grid.o:(.bss+0x60): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    ENV["LDADD"] = "-lncurses -lm" unless OS.mac?
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    inreplace "src/Makefile", /chgrp .*/, ""
    system "make", "install"
  end

  test do
    assert_match(/nsuds version #{version}$/, shell_output("#{bin}/nsuds -v"))
  end
end
