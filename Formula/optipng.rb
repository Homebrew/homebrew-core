class Optipng < Formula
  desc "PNG file optimizer"
  homepage "https://optipng.sourceforge.io/"
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
  end

  bottle do
    cellar :any_skip_relocation
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
