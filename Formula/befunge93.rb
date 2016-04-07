class Befunge93 < Formula
  desc "Esoteric programming language"
  homepage "http://catseye.tc/node/Befunge-93.html"
  url "http://catseye.tc/distfiles/befunge-93-2.23-2015.0101.zip"
  version "2.23-2015.0101"
  sha256 "7ca6509b9d25627f90b9ff81da896a8ab54853e87a5be918d79cf425bcb8246e"
  head "https://github.com/catseye/Befunge-93.git"

  def install
    system "make"
    bin.install Dir["bin/bef*"]
  end

  test do
    (testpath/"test.bf").write '"dlroW olleH" ,,,,,,,,,,, @'
    assert_match /Hello World/, shell_output("#{bin}/bef test.bf")
  end
end
