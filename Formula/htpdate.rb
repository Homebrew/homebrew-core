class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "http://www.vervest.org/fiki/bin/view/HTP"
  url "http://www.vervest.org/htp/archive/c/htpdate-0.9.1.tar.bz2"
  sha256 "2afd132b00d33cd45eea9445387441174fe9bedf3fdf72c5a19f0051cf5a2446"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5490cb23845604c332f2e5536639d7cb87ecc75fc3b6f8e0f8e799fc959a320" => :sierra
    sha256 "fbdf082a4cbde49e5a9e5ea28f8f9c76e634d1f4fc79397e70e55306947c37b8" => :el_capitan
    sha256 "56073fc56009dac7f807d436f09732bf4e659d2374bb6a61646dc7f94740daa0" => :yosemite
    sha256 "973fb72128a9fe5e0c4c1aaaf9671b4ea706bc98ba5f96ecd10a2dae46049e57" => :mavericks
  end

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/htpdate", "-h"
  end
end
