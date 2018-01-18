class Idnits < Formula
  desc "Looks for problems in internet draft formatting"
  homepage "https://tools.ietf.org/tools/idnits/"
  url "https://tools.ietf.org/tools/idnits/idnits-2.15.01.tgz"
  sha256 "b5a7a946d5d76ab7e3797871b64d1f904214ecdf94daa13c1c8da400980ea6b5"

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
      system "#{bin}/idnits", "draft-ietf-tcpm-undeployed-03.txt"
    end
  end
end
