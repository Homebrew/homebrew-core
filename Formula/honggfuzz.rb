class Honggfuzz < Formula
  desc "Security oriented software fuzzer"
  homepage "https://honggfuzz.dev"
  url "https://github.com/google/honggfuzz/archive/2.3.1.tar.gz"
  sha256 "3b1c8fbcd0a4ca9db72d88bfc74bc44edb78ccf386264549fb5f9bcf8f4fab72"
  license "Apache-2.0"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/badcode/.", testpath
    cd "targets" do
      system "make"
    end
    output = shell_output("#{bin}/honggfuzz -N 10 -i inputfiles -- targets/badcode1 ___FILE___ 2>&1")
    assert_match "Summary", output
  end
end
