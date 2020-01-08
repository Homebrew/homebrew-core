class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.6.0.tar.gz"
  sha256 "970d5ecbde6bb370c8178339db42e7812b7a2f3a5db3eec868cc18c19523c0ea"
  revision 4

  bottle do
    sha256 "f040106e20bebbcfea61a12cee83b3cdaaeb484bc3ab3b590206f1897ca6dc99" => :catalina
    sha256 "bc19b1b359cd9f78137fd11199a87856d727eb6769a38ae8e009613296188fca" => :mojave
    sha256 "69a0f31e9738fc6eb89364f507e0867b249614845a0b5d734955e29096c8903d" => :high_sierra
    sha256 "1bd7c503764108164362adfa4530de7629f19293ea1c9052dc5da77dca0b52c0" => :sierra
  end

  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@1.1"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
