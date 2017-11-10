class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.79.tar.gz"
  sha256 "d8b25f788545e036f2b2fd9c246d7f3143ac8d4fd35378784d9cbb4325e5077f"

  bottle do
    sha256 "a583168713ae49a27723f16a1235c074d52d02c235b64bbf168406235e778823" => :high_sierra
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
