class Befunge93 < Formula
  desc "Esoteric programming language"
  homepage "http://catseye.tc/node/Befunge-93.html"
  url "http://catseye.tc/distfiles/befunge-93-2.23-2015.0101.zip"
  version "2.23-2015.0101"
  sha256 "7ca6509b9d25627f90b9ff81da896a8ab54853e87a5be918d79cf425bcb8246e"
  head "https://github.com/catseye/Befunge-93.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b2b344570f71b3fa702675b2305b96632fde0a8da44085a15b15fe72863f66a" => :sierra
    sha256 "fcebeb62391bd6e3eef571123af573766666ce9c40f139c889cc350bf6410d8b" => :el_capitan
    sha256 "825c5d86e93d7cf0ecc2f3f16f626c27e658f1d4792bd6e74092b11f815097d7" => :yosemite
    sha256 "a4f6102ac80c19ef969e7b2bbe70bdfd4f192df08d455b2b6162ce16e3616564" => :mavericks
  end

  def install
    system "make"
    bin.install Dir["bin/bef*"]
  end

  test do
    (testpath/"test.bf").write '"dlroW olleH" ,,,,,,,,,,, @'
    assert_match /Hello World/, shell_output("#{bin}/bef test.bf")
  end
end
