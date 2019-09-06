class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.85.tar.gz"
  sha256 "aaa8c96c31e533f238e03b1d91d6a6b5e95bed25a8b89a48d64d67fcfe8c7e89"

  bottle do
    sha256 "6294e2a7a132be9cbda76ff8a8529971a0a034a06455060fad7746cb32b0767a" => :mojave
    sha256 "e5ce6aaea5ca0a7f0680d57fc9ff2d74128bda489bd0f1cc89e7c2f40ddc6958" => :high_sierra
    sha256 "8204000310cac65645b48f68855aacd3f8257d11395f9e96b2751c0831c0628f" => :sierra
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
