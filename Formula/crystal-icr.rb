class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.6.0.tar.gz"
  sha256 "970d5ecbde6bb370c8178339db42e7812b7a2f3a5db3eec868cc18c19523c0ea"
  revision 1

  bottle do
    sha256 "b623200d377ee356c083db16c9a27b5f8b4a49439d308291de3e866d06229fcf" => :mojave
    sha256 "fb253d4602327a09a5828fda371fa0bc318f79ffd96163926de5f19f338c675b" => :high_sierra
    sha256 "45aed3c4edbb7d3ae2d93c093a3bafe9296760693a1fe02d28180e20bd2feecc" => :sierra
  end

  depends_on "crystal"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
