class Idnits < Formula
  desc "Looks for problems in internet draft formatting"
  homepage "https://tools.ietf.org/tools/idnits/"
  url "https://tools.ietf.org/tools/idnits/idnits-2.16.04.tgz"
  sha256 "1eef34b131d9c0b45090192f972db0b5dae15047271a7962959c8019dd8cc06b"

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
