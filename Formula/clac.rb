class Clac < Formula
  desc "Command-line, stack-based calculator with postfix notation"
  homepage "https://github.com/soveran/clac"
  url "https://github.com/soveran/clac/archive/0.3.2.tar.gz"
  sha256 "37a926982a3cc5016b42c554deaa5c64fa3932ebacd5bd15003508cf79a666dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaea6c0a7d8c809bfdb43219509873b6cec87593b45b9b2fae4a51d37c197102" => :catalina
    sha256 "f88ab13f5b80ecad66b4104df24a41932deb7da4a6bed46f1dbe3ad18889817f" => :mojave
    sha256 "b6e5fd38ba066369ed384eb016cbc0a56411ec46f22b0e7399f21009a16b8720" => :high_sierra
    sha256 "7e1fa4bcd0c7aed8586f7036e3d1fce149a5d4b321f496163ea5aaedbad60596" => :sierra
    sha256 "21200708adb21d70fde9197daa3a73c9029b420a992878761e9054ec5389c6af" => :el_capitan
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "7", shell_output("#{bin}/clac '3 4 +'").strip
  end
end
