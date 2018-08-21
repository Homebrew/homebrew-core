class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20171017.tgz"
  sha256 "db17115d1ed18ed1607c8b93291db9ccd4fe5e0f30d2928c3c5d127b23ec9e5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "87b33818e9d764d65aa7690eef44dbd2596e02826cf78123ccd12591ee9498af" => :mojave
    sha256 "c5cf51c1eba34b38ca2e9d3409842a0cf4af5e00f1436bf84b164d2a4385f572" => :high_sierra
    sha256 "f5ff9c8eba46e085ad689358a2d969d8949dee1c850c2125f388776f54e61700" => :sierra
    sha256 "4ef13dbc1202c66b982a91a103ed3d3204b036c0ab63b2f30938662c14436f68" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = shell_output("#{bin}/mawk -W version 2>&1 | #{bin}/mawk '#{mawk_expr}'")
    assert_equal version.to_s, ver_out
  end
end
