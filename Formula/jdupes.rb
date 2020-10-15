class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.19.0.tar.gz"
  sha256 "98676d3455c89882c3f7f4934602f9e7aca2b054caf3f0deaf286552ce9b276b"
  license "MIT"

  livecheck do
    url "https://github.com/jbruchon/jdupes/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
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
