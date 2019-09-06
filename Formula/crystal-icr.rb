class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.6.0.tar.gz"
  sha256 "970d5ecbde6bb370c8178339db42e7812b7a2f3a5db3eec868cc18c19523c0ea"
  revision 3

  bottle do
    sha256 "7cdbe58b126c174512c1b58d0c8182a6e04af9ac5a5375faa37f62386da4e360" => :mojave
    sha256 "e55738972fe09c6f825f8722b188d5636d128823fafba4fbfde1901a5e59cd3b" => :high_sierra
    sha256 "bafa1310e8ff7f816d8b579591020023523889206d38505a5d0fabda3ca33339" => :sierra
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
