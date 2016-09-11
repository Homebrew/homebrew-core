class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-3.10.tar.gz"
  sha256 "3b555e5f7b35ab6a4558bc460f28d80b32f5a211bf9e08d6a1ba1bad5203e3e9"

  bottle do
    sha256 "8b949ce43ea720d7556ab6bea03193c9b7d680e5139fe813192330d2b9b6138a" => :el_capitan
    sha256 "779e7022d29291278cff532258596b74586a134d64819869854d3f5cb333ee50" => :yosemite
  end

  depends_on "gnu-sed" => :build

  # Upstream could not fix OpenCL issue on Mavericks.
  # https://github.com/hashcat/hashcat/issues/366
  # https://github.com/Homebrew/homebrew-core/pull/4395
  depends_on :macos => :yosemite

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    cp_r pkgshare.children, testpath
    cp bin/"hashcat", testpath
    (testpath/"my.dict").write <<-EOS.undent
      foo
      test
      bar
    EOS
    hash = "098f6bcd4621d373cade4e832627b4f6"
    cmd = "./hashcat -m 0 --potfile-disable --quiet #{hash} #{testpath}/my.dict"
    assert_equal "#{hash}:test", shell_output(cmd).chomp
  end
end
