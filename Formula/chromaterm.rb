class Chromaterm < Formula
  desc "Colorize your terminal's output using RegEx"
  homepage "https://github.com/hSaria/ChromaTerm--"
  url "https://github.com/hSaria/ChromaTerm--/archive/0.3.4.tar.gz"
  sha256 "9e7d3b5884357fbb7b89b307769652a61358b45849215fd8484255c3f98f9203"

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    Dir.chdir "src/"
    system "./configure", "--prefix=#{prefix}"
    system "make"

    bin.install "ct"
    man1.mkpath
    man1.install "../ct.1"
  end

  test do
    system "#{bin}/ct", "-d"
  end
end
