class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.90.tar.gz"
  sha256 "fbb3811aa0ac4b31e1702ea643dd3a6a617b2516ad6f9cfab76ec2779618e5a4"
  license "MIT"

  livecheck do
    url "https://www.nickle.org/release/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:      "6e377f6674d6609f634b28941d8c53fef94c9cb429f31d1c765e4a5d8607e88d"
    sha256 catalina:     "3e1d028467ee41d963e9eaa9809f288fbc3effd826e09ae69bd4e4bfd26679c5"
    sha256 mojave:       "6fa77667c30e0dfa186868159076bd2e003c34d32624915481f8c52e68b97f23"
    sha256 x86_64_linux: "a80572816adbeb145a3dd76b327bff79653d6ff504eba14b9fb767e73c64a992"
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
