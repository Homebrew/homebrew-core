class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/JohnSully/KeyDB/archive/v5.3.3.tar.gz"
  sha256 "07ad8344984ed8c896b75d19863c11cd7e9786220d93c9abaa3a65c34df075a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "af562aac5b3bdc1fd73a052b18ecc191e558e149fc874f9292edaccb58cb9ea2" => :catalina
    sha256 "7ee213166db5963069cf66f1b364923e978ae5556741c9e2621103b02c51ce58" => :mojave
    sha256 "5c889f1e756e3291a9ce8b9c96d5649e03c860d6cbf100fb015faf4ac964ec27" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end
