class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.6.0.tar.gz"
  sha256 "970d5ecbde6bb370c8178339db42e7812b7a2f3a5db3eec868cc18c19523c0ea"

  bottle do
    sha256 "02a8c6c556b777a289a5e16f0844e00594015c8c9aef4ee1ab14d48aa605524d" => :mojave
    sha256 "1eaf80242e1ab6800378fb531d5fa843a6131d661ef73fccf174ad590f2ae43c" => :high_sierra
    sha256 "1fe165c33497947f796d274122ca01ee0b387480edd7f1400af1ed15932f5ac9" => :sierra
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
