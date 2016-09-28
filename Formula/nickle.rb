class Nickle < Formula
  desc "Desk calculator language"
  homepage "http://www.nickle.org/"
  url "http://www.nickle.org/release/nickle-2.77.tar.gz"
  sha256 "a35e7ac9a3aa41625034db5c809effc208edd2af6a4adf3f4776fe60d9911166"
  revision 1

  bottle do
    sha256 "a2d3f5a56b899ed3e54dfd62c3b3aff91a9e0f1b071be4edd558b56a969b009d" => :sierra
    sha256 "aa3bb8a61763ebeaac001e02b7fb21c5733ccf0c2fbeea02908959d2fec03b5c" => :el_capitan
    sha256 "889ae51c6ba498cdfe72556ef59b4d3e640d848c77d1fa69dfcbddf01441fefe" => :yosemite
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
