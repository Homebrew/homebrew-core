class Pms < Formula
  desc "Practical Music Search, an ncurses-based MPD client"
  homepage "https://pms.sourceforge.io"
  url "https://downloads.sourceforge.net/project/pms/pms/0.42/pms-0.42.tar.bz2"
  sha256 "96bf942b08cba10ee891a63eeccad307fd082ef3bd20be879f189e1959e775a6"

  bottle do
    sha256 "9526998c8cbe888fcf0b494d4d717b3b8cc9501b5f559c719274dd1de75d2d1a" => :mojave
    sha256 "6a7b2229b39104ec96032e9e893514fa8a61b18a52106729332c22d8aba8a065" => :high_sierra
    sha256 "8d96a7dafe25504a4bf927b94119265f6dfd0459aaaed9d1867601aa24ed8728" => :sierra
    sha256 "65b6bfe7e5eca6e7f073e4f9c3fc7c46df538c91010059781369bacbc628256b" => :el_capitan
    sha256 "4093093ca7be2f6aaee5f50d3185323df4fcea2ed389f29615a1b79fb3648be4" => :yosemite
    sha256 "2f7dd91d357ac34393e55d7de6ffca2b21a64adfa084a6b6dd5c5aa43caed170" => :mavericks
    sha256 "772bff39de0b88e164b5f14b22ed4fa22c274468d07d735318284fee5157d6c1" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(/Practical Music Search v#{version}/,
                 shell_output("#{bin}/pms -?", 4))
  end
end
