class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.1/E.tgz"
  sha256 "f4d8b0316dfe670b636e85382d0d9802fe723b6e13c316497163a85fa54a09be"

  bottle do
    sha256 "f093c240c7a2b59841706a8e14b257b1a4e21d2042c19bed5a5a3ccf55908608" => :mojave
    sha256 "25b002f9ebea09a19061dc34ecdf9df013c8e2dc10a591cfa52a35a817702c79" => :high_sierra
    sha256 "3bc21a8ded282e64ee8ed8062eec514133af36d2418e18f7821c4c678e288b54" => :sierra
    sha256 "3c91a8bc24e98889448a78fdccc888d5f6489a9715e903b255026b11dd5ff1b7" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eprover", "--help"
  end
end
