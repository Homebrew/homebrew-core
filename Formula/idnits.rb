class Idnits < Formula
  desc "Looks for problems in internet draft formatting"
  homepage "https://tools.ietf.org/tools/idnits/"
  url "https://tools.ietf.org/tools/idnits/idnits-2.14.01.tgz"
  sha256 "5b49749b0e4dc610fae9c12780c7a4d02723a5f4b701271bdd374d909c186654"

  bottle :unneeded

  depends_on "aspell"
  depends_on "languagetool"

  def install
    bin.install "idnits"
  end

  test do
    system "idnits --version"
  end
end
