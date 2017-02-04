class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftpmirror.gnu.org/ddrescue/ddrescue-1.22.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.22.tar.lz"
  sha256 "09857b2e8074813ac19da5d262890f722e5f7900e521a4c60354cef95eea10a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "2408aa74d3d6da31f292c806b217572cae8e1f36baaaa62a32fab30337f49835" => :sierra
    sha256 "aff05728f88adac5a71d75062b20fcdeafbf2713b85ee36fab5feb61b7bdb61e" => :el_capitan
    sha256 "42107fcfff8293ad3fc0d0e2720a51ebb0d3a2f760de0b8726f4f8d950765486" => :yosemite
    sha256 "d0ee3b88a28d423f6475d0046307bddfdeb210f56fb59878b6395b2a01144073" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", "/dev/null"
  end
end
