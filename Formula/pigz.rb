class Pigz < Formula
  desc "Parallel gzip"
  homepage "http://www.zlib.net/pigz/"
  url "http://www.zlib.net/pigz/pigz-2.3.4.tar.gz"
  sha256 "6f031fa40bc15b1d80d502ff91f83ba14f4b079e886bfb83221374f7bf5c8f9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "77c7dd4cfeceb81c8dcd23111b4525787865041e3063de7a4fa914436c4118a9" => :sierra
    sha256 "da62a529c056e783189a3ece7ba48fb4c0f9dc05f42ab56d380a14f4987edac0" => :el_capitan
    sha256 "d687730db97facbbfcd47226c7f7737f1354cfa0bc11eb7a1f70f79520b44fd4" => :yosemite
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    man1.install_symlink "pigz.1" => "unpigz.1"
  end

  test do
    test_data = "a" * 1000
    (testpath/"example").write test_data
    system bin/"pigz", testpath/"example"
    assert (testpath/"example.gz").file?
    system bin/"unpigz", testpath/"example.gz"
    assert_equal test_data, (testpath/"example").read
  end
end
