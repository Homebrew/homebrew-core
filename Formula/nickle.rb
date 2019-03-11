class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.81.tar.gz"
  sha256 "99a9331489e290fb768bf8d88e8b03e76f25485d7636c30d9eee616ca9d358b5"
  revision 1

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
