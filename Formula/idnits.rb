class Idnits < Formula
  desc "Looks for problems in internet draft formatting"
  homepage "https://tools.ietf.org/tools/idnits/"
  url "https://tools.ietf.org/tools/idnits/idnits-2.14.01.tgz"
  sha256 "5b49749b0e4dc610fae9c12780c7a4d02723a5f4b701271bdd374d909c186654"

  bottle :unneeded

  depends_on "aspell" => :optional
  depends_on "languagetool" => :optional

  resource "test" do
    url "https://tools.ietf.org/id/draft-ietf-tcpm-undeployed-03.txt"
    sha256 "34e72c2c089409dc1935e18f75351025af3cfc253dee50db042d188b46733550"
  end

  def install
    bin.install "idnits"
  end

  test do
    resource("test").stage do
      system "idnits", "draft-ietf-tcpm-undeployed-03.txt"
    end
  end
end
