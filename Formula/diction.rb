class Diction < Formula
  desc "GNU diction and style"
  homepage "https://www.gnu.org/software/diction/"
  url "https://ftp.gnu.org/gnu/diction/diction-1.11.tar.gz"
  mirror "https://ftpmirror.gnu.org/diction/diction-1.11.tar.gz"
  sha256 "35c2f1bf8ddf0d5fa9f737ffc8e55230736e5d850ff40b57fdf5ef1d7aa024f6"

  bottle do
    sha256 "ff26ae017482eaef3a07b4c6522e65a84b2ec03b6afaffa20e0138a244edd5e2" => :catalina
    sha256 "74ffc9abed7808557c799d089d4336da01d68c484e7b90dac797015d9656c8de" => :mojave
    sha256 "194a52459b3bfd3e4f38f8e19ea9f4d371d2bf3b005d3e36b8aa5519c5afaf2d" => :high_sierra
    sha256 "70dbde26567eb6b0093d897f9ceafb212eaf51d23028a925d39c0f53b803b5b9" => :sierra
    sha256 "858b8312ef527a7745a02b3bf40cd483c0212216e3342ac7eaddbfe6045893dd" => :el_capitan
    sha256 "ce2b0d6b0f7184596753de94a3cbd171f5236c947f47536d3bf5be806c8ef804" => :yosemite
    sha256 "b993bef13629751dc5ac23a38e67ea8fdce3e75f0d96585dc71508543e099f0e" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    file = "test.txt"
    (testpath/file).write "The quick brown fox jumps over the lazy dog."
    assert_match /^.*35 characters.*9 words.*$/m, shell_output("#{bin}/style #{file}")
    assert_match /No phrases in 1 sentence found./, shell_output("#{bin}/diction #{file}")
  end
end
