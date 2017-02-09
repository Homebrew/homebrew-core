class Pex < Formula
  desc "Package manager for PostgreSQL"
  homepage "https://github.com/petere/pex"
  url "https://github.com/petere/pex/archive/1.20140409.tar.gz"
  sha256 "5047946a2f83e00de4096cd2c3b1546bc07be431d758f97764a36b32b8f0ae57"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "d05367457fca17897b99d20bf3c2066174da17a06fb4207809a167a0f3d03b19" => :sierra
    sha256 "d05367457fca17897b99d20bf3c2066174da17a06fb4207809a167a0f3d03b19" => :el_capitan
    sha256 "d05367457fca17897b99d20bf3c2066174da17a06fb4207809a167a0f3d03b19" => :yosemite
  end

  depends_on :postgresql

  def install
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
  end

  def caveats; <<-EOS.undent
    If installing for the first time, perform the following in order to setup the necessary directory structure:
      pex init
    EOS
  end

  test do
    assert_match "share/pex/packages", shell_output("#{bin}/pex --repo").strip
  end
end
