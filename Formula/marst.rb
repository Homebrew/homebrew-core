class Marst < Formula
  desc "Algol-to-C translator"
  homepage "https://www.gnu.org/software/marst"
  url "https://ftp.gnu.org/gnu/marst/marst-2.7.tar.gz"
  sha256 "3ee7b9d1cbe3cd9fb5f622717da7bb5506f1a6da3b30f812e2384b87bce4da50"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0e07b482a8c8ebf7cb4b874a9c81e4c69776adf87443ede2253a8871a0db73d7" => :mojave
    sha256 "69eceb01e8925d4b0eecbf40fd9b24504864c7f84f1a40b596f28f8903b0e6ca" => :high_sierra
    sha256 "23fecf40d2b6ac2c986d61789bcb9dcf9b0e4926521294ea23dc7703f042bcb2" => :sierra
    sha256 "c1a70d467ff3117c2a31bd52a659fbff2293f6f17b11cd4b370e9e8220a483c8" => :el_capitan
    sha256 "6d8834fc64e1da37fce2ed9cae3c9f0e0dbfcb41f213c55c8413c2a522ed8811" => :yosemite
    sha256 "7fddf8023d17c4bfcb6fc4141c6202b3e856ee2ecd684236daef058592b79335" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.alg").write('begin outstring(1, "Hello, world!\n") end')
    system "#{bin}/marst", "-o", "hello.c", "hello.alg"
    system ENV.cc, "hello.c", "-lalgol", "-lm", "-o", "hello"
    system "./hello"
  end
end
