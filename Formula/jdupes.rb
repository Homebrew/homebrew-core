class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.19.1.tar.gz"
  sha256 "bb7c53cd463ab5e21da85948c4662a3b7ac9b038ae993cc14ccf793d2472e2e9"
  license "MIT"

  livecheck do
    url "https://github.com/jbruchon/jdupes/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9588e410df4f34d12d68ee4605ca3e2dc3a35b5a7112dcb05352de07951b2bf2" => :big_sur
    sha256 "46fec950c90e6d2306884dc961d508368e744b6b3b516a1c935930c694f5dd4b" => :catalina
    sha256 "d1c88242da6c924d310427620cdef06190b33f9a60c9633f1439df7caddc8f05" => :mojave
    sha256 "654d11b34e057cff3150e264d2dbf10d8d2114a9529cb20ab6c76865fd6caf7e" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
