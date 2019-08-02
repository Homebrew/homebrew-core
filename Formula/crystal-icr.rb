class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.6.0.tar.gz"
  sha256 "970d5ecbde6bb370c8178339db42e7812b7a2f3a5db3eec868cc18c19523c0ea"
  revision 3

  bottle do
    sha256 "91e9a61aa1b45edb14bb8a9a382fc047d67e83cf6afa8448302bad7b4af3a335" => :mojave
    sha256 "e5f01557473604039d63fe72104f0aaa60cc966490864d9426a69fb35556948a" => :high_sierra
    sha256 "7e8d70d366e73788a9866d21db52daad3783c2ea98ec3425bcbb44196547a01d" => :sierra
  end

  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
