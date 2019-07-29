class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.84.tar.gz"
  sha256 "ba785eaa352264d638168bf88abacf2e36aa32b881805bc8181b4f3dc26a74d5"

  bottle do
    sha256 "262e7e8d0b52db18b4b0b1a4a7321426de89d9f38187c65d65ab74c27c509fe4" => :mojave
    sha256 "ff770368cd5b75b94e0e899319f7280656b1d7c6f1b66690785291b03c10896d" => :high_sierra
    sha256 "7f984d10d78fb536976ef1ec1c88d0870d40b2eab603c5ca84e80d898ec02f7e" => :sierra
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
