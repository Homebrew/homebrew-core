class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.22.tar.lz"
  mirror "https://ftpmirror.gnu.org/ddrescue/ddrescue-1.22.tar.lz"
  sha256 "09857b2e8074813ac19da5d262890f722e5f7900e521a4c60354cef95eea10a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "8447d5e790a6c9104a371a832f7cfee2c9eb7f277dc5da983e5be750179d6e30" => :sierra
    sha256 "a06368bfafcac4f88002e0a98afe7e1ccd37f44f292ef5182676027017328d3a" => :el_capitan
    sha256 "2e62a4d56355d1e3fbfe40e77279382335dd9a16f43db40df87c1cfb68be1aa7" => :yosemite
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
