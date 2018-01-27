class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.5.0.tar.gz"
  sha256 "f2b5cb971b368085e9c4f607d906e0622aa94d65c0f7c820d9cbdf23fb972c33"
  revision 1

  bottle do
    sha256 "114bfed2c7e7f7428b9c06668b37b8eb346dd01b7d9064d3cb16089189b5b78a" => :high_sierra
    sha256 "8a16ff49e83574e05f35ea5fc77fa24fc380babaab1128d67e4476202055c552" => :sierra
    sha256 "0bdb50bd547c9d153dd2cd07bba5979a09242a3dbcf53856cc118e32c307736b" => :el_capitan
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
