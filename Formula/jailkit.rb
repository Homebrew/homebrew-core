class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "https://olivier.sessink.nl/jailkit/"
  url "https://olivier.sessink.nl/jailkit/jailkit-2.20.tar.bz2"
  sha256 "8db7b54f4bef9f205d88fb23bfd0b74dd7c8d8495045009ef5146c61e458a0b2"

  bottle do
    sha256 "8de16a27592d62469f074c6c5296451d80f3aef3bbaf5c017c884b5ae1d209cf" => :catalina
    sha256 "1442d9932b7b8b539118d9fb98fd4e6a73f9da2b436c8cd5d1efd3cd3e05c2a7" => :mojave
    sha256 "dd024c14e4ac619ec32581322550942b875a324b80320990a8a5242aa54e5c6b" => :high_sierra
    sha256 "34a77f5ddba7f627d0e7c5bdd524a1bfa55ef56662e2e29305d35602dbfccc63" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
