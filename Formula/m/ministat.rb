class Ministat < Formula
  desc "Small tool to do the statistics legwork on benchmarks etc."
  homepage "https://github.com/leahneukirchen/ministat"
  url "https://github.com/leahneukirchen/ministat/archive/refs/tags/v15.0.tar.gz"
  sha256 "9e429718d3dac225ea4014ba5758b9b45ac3ff30ca101a325a111e58551d6f68"
  license "Beerware"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test-data").write <<~EOS
      1
      2
      3
      4
      5
    EOS
    system bin/"ministat", testpath/"test-data"
  end
end
