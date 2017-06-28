class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2017.03.21.tar.xz"
  mirror "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2017.03.21.tar.xz"
  sha256 "386ad455f12bdeb3a7d19280441a5ab77355142349200ff11040a8d9d455d765"

  bottle do
    cellar :any_skip_relocation
    sha256 "18a7ad691fb79f0e2494045c931d9f9e6cfa23f5778dbf5ee68476d36bac80aa" => :sierra
    sha256 "18a7ad691fb79f0e2494045c931d9f9e6cfa23f5778dbf5ee68476d36bac80aa" => :el_capitan
    sha256 "18a7ad691fb79f0e2494045c931d9f9e6cfa23f5778dbf5ee68476d36bac80aa" => :yosemite
  end

  # autoconf-archive is useless without autoconf
  depends_on "autoconf" => :run

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.m4").write <<-EOS.undent
      AC_INIT(myconfig, version-0.1)
      AC_MSG_NOTICE([Hello, world.])

      m4_include([#{share}/aclocal/ax_have_select.m4])

      # from https://www.gnu.org/software/autoconf-archive/ax_have_select.html
      AX_HAVE_SELECT(
        [AX_CONFIG_FEATURE_ENABLE(select)],
        [AX_CONFIG_FEATURE_DISABLE(select)])
      AX_CONFIG_FEATURE(
        [select], [This platform supports select(7)],
        [HAVE_SELECT], [This platform supports select(7).])
    EOS

    system "#{Formula["autoconf"].bin}/autoconf", "test.m4"
  end
end
