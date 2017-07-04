class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.6.6.tar.bz2"
  sha256 "608ef935f7a377e1439c181c4fc188d247da10d51a19ef79bcdee5043b0973f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "231a659ee3aca5a6f474bc058ed02a0a5f2c366d04c8c56043d310644c46e393" => :sierra
    sha256 "d461d873a47091a52b6114ac0976f16b0ade9e13d02fa0609f574369b8cfc8f0" => :el_capitan
    sha256 "0c4d4a90c188370ed312490b7ff76fdb8a31399170cdc0ad5dfc1542af4c4fc0" => :yosemite
  end

  option "with-gettext", "Build with Native Language Support"

  depends_on "gettext" => :optional

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--disable-nls" if build.without? "gettext"

    system "./configure", *args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip
  end
end
