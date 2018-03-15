class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2018.02.28.tar.gz"
  sha256 "2db4f05616bdd21a609baf82c836486c44820c16a006315e02abe2b0b53a247e"

  bottle do
    cellar :any_skip_relocation
    sha256 "060936774f57ced6f74278d1fe807ac70040f56fd755271dc738cfc868a9059d" => :high_sierra
    sha256 "1e126de1eed29c831eba0dca9f589d80f59af17c60bc75fecf2ea54b7218c703" => :sierra
    sha256 "5b913b90d96a394d9ede3a287ffb7ad8b148661369987f632e449e7cf7e8f3ca" => :el_capitan
  end

  def install
    system "./genMakefiles", "macosx"
    system "make", "PREFIX=#{prefix}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats; <<~EOS
    Testing executables have been placed in:
      #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
