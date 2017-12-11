class Optipng < Formula
  desc "PNG file optimizer"
  homepage "https://optipng.sourceforge.io/"
  revision 1

  head "http://hg.code.sf.net/p/optipng/mercurial", :using => :hg

  stable do
    url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.6/optipng-0.7.6.tar.gz"
    sha256 "4870631fcbd3825605f00a168b8debf44ea1cda8ef98a73e5411eee97199be80"

    # Patch for missing st_atim from struct stat on macOS 10.13.
    #
    # The block referencing st_atim used to be guarded by defined UTIME_NOW &&
    # defined UTIME_OMIT, but futimens(2) and utimensat(2) have been added in
    # macOS 10.13, and these macros are now defined.
    #
    # Issue reported and patch submitted to upstream on 2017-07-08:
    #   https://sourceforge.net/p/optipng/patches/9/
    # (Submitted patch is not exactly the same, because the code at question
    # has moved to another file in head.)
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/a42e7b3/optipng/optipng-10.13-st_atim.patch"
      sha256 "89849450fa922af0c96e64e316b5f626ec46486cb5d59f85cd4716d2c5fa0173"
    end

    # https://sourceforge.net/p/optipng/bugs/69/ - CVE-2017-16938
    # https://sourceforge.net/p/optipng/bugs/65/ - CVE-2017-1000229
    # Upstream fixes for both should land in 0.7.7, which is due before 2018.
    patch do
      url "https://mirrors.ocf.berkeley.edu/debian/pool/main/o/optipng/optipng_0.7.6-1.1.debian.tar.bz2"
      mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/o/optipng/optipng_0.7.6-1.1.debian.tar.bz2"
      sha256 "eef445316b92630920839a0f7249f1a041bafaa95e18c3188eabb84f41d52851"
      apply "patches/CVE-2017-16938",
            "patches/CVE-2017-1000229"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "aff38232e7e6a32f60197658a3ce8c94bcbaeb9f64dfdfdbb4620ab52a580604" => :high_sierra
    sha256 "41a2a04cfa3a8a39292157a4410a345236747a5e3c992c58e2cf364d2ed0dd9b" => :sierra
    sha256 "b062317980451b8a6a129e87f3a22ae851e42c498775a9c5a0e885d265425450" => :el_capitan
    sha256 "a8b8c3682ae147ff68f37db1155ecd86c965e6e5c4fc0e20b0da3297060cbea2" => :yosemite
    sha256 "64e1d9fd2a5dd56a91af23ab2a170f68fa06993b2b1ed539b17ffad086e1e28f" => :mavericks
  end

  def install
    system "./configure", "--with-system-zlib",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/optipng", "-simulate", test_fixtures("test.png")
  end
end
