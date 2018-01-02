class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.5.0.tar.gz"
  sha256 "f2b5cb971b368085e9c4f607d906e0622aa94d65c0f7c820d9cbdf23fb972c33"

  bottle do
    sha256 "4a29d32a127a60f4d4220eb2cfa582023ca9ed18d18e5b1202a48e2934ce39a0" => :high_sierra
    sha256 "d188609e6db0e8ff98263ff8ccef6aec1dc86aa5e036156d491dead73f564556" => :sierra
    sha256 "a4746f37993c2c62cc324b484164556f1780e5308cf606f4fd8c4f5c9260b5f7" => :el_capitan
  end

  depends_on "crystal-lang"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
