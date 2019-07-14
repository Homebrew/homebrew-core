class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.84.tar.gz"
  sha256 "ba785eaa352264d638168bf88abacf2e36aa32b881805bc8181b4f3dc26a74d5"

  bottle do
    sha256 "0f2df376f4844e68bff024867233a87bb81e72bf7596a396c25d957976c25179" => :mojave
    sha256 "b10a7bab81cafce5c1f21a9b52eba9f69944c0d1e8104415bf6efc478676546b" => :high_sierra
    sha256 "e1e8b1026149286d819e57a5e674eb51d5b50f31f243ce06004824162e258ded" => :sierra
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
