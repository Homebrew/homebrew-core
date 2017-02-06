class GnuShogi < Formula
  desc "GNU Shogi (Japanese Chess)"
  homepage "https://www.gnu.org/software/gnushogi/"
  url "https://ftpmirror.gnu.org/gnushogi/gnushogi-1.4.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnushogi/gnushogi-1.4.2.tar.gz"
  sha256 "1ecc48a866303c63652552b325d685e7ef5e9893244080291a61d96505d52b29"

  bottle do
    sha256 "d5f6a61a19d4a7021f7df9a2531ac416a20bda3c5ac57e03c388634d62aafe8e" => :yosemite
    sha256 "f6b79feeeed71109d169782a5cfd744073b4d7e18cd56f6a97bfa0d551225083" => :mavericks
    sha256 "40db203ce21ba253edf1bd714bae5f065e9119cc9cadfde4439d18dd45db343a" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install", "MANDIR=#{man6}", "INFODIR=#{info}"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      7g7f
      exit
    EOS
    system "#{bin}/gnushogi < test"
  end
end
