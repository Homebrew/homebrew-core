class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.10.2.tar.gz"
  sha256 "6c79035e2d349d0b1d749881b06a24ca43afc5b8f7e714c99b90a34b4618ed4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8ef99cc179edeedb76780de8a4b90ffe000c1e614cae70452240d2de6d54646" => :high_sierra
    sha256 "db20c7450f27fc5bc4dcff7586b600ae93efae704a5109ece2f8806993a09722" => :sierra
    sha256 "51d832097770ea6fbe68e0ff509a16c493e12ba4d62e8bcd7182a36be8ff43ad" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
