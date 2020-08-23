class Fetchmail < Formula
  desc "Fetch mail from a POP, IMAP, ETRN, or ODMR-capable server"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.8.tar.xz"
  sha256 "26cd936ece146e056cdf79a676a33738b4eab0a5ae2edf3fce5ba034721b09bd"

  bottle do
    cellar :any
    sha256 "8bdfcb38c5780d0d7647376f4be9f4b61d9966a22410e11f9e5911edc29b599e" => :catalina
    sha256 "ae51c7a930d412e2665d12649d3649e941ed42e5cd4029a31e72324f6c219622" => :mojave
    sha256 "5a3a990aaf600df8aa7fc429a657766a9f46abac35469bce0611ac1cd953e782" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
