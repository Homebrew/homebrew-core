class Idnits < Formula
  desc "Looks for problems in internet draft formatting"
  homepage "https://tools.ietf.org/tools/idnits/"
  url "https://tools.ietf.org/tools/idnits/idnits-2.16.05.tgz"
  sha256 "9f30827e0cf7cf02245e248266ece9557886d33ec7a90cc704b450e70f2cead5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?idnits[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle :unneeded

  resource "test" do
    url "https://tools.ietf.org/id/draft-ietf-tcpm-undeployed-03.txt"
    sha256 "34e72c2c089409dc1935e18f75351025af3cfc253dee50db042d188b46733550"
  end

  def install
    bin.install "idnits"
  end

  test do
    resource("test").stage do
      system "#{bin}/idnits", "draft-ietf-tcpm-undeployed-03.txt"
    end
  end
end
