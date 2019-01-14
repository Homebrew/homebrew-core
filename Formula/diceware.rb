class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://github.com/ulif/diceware/archive/v0.9.6.tar.gz"
  sha256 "ff55832e725abff212dec1a2cb6e1c3545ae782b5f49ec91ec870a2b50e1f0e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "0337fa5b3f3b8975a3e98dcf2cc547f0b49362bba602c8ae0ba04c6bcd9775fd" => :mojave
    sha256 "860337c1b1054ebdab64426b10cdcc1b5f508bd327560f78273ccfba348d9e1e" => :high_sierra
    sha256 "7fd4218db14b490a0b2b0f5372c636dced0801829a16278f7751d3d831f79785" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(/(\w+)(\-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
