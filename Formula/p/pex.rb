class Pex < Formula
  desc "Package manager for PostgreSQL"
  homepage "https://github.com/petere/pex"
  url "https://github.com/petere/pex/archive/refs/tags/1.20140409.tar.gz"
  sha256 "5047946a2f83e00de4096cd2c3b1546bc07be431d758f97764a36b32b8f0ae57"
  license "MIT"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "81df4ae64bf5d25705cdb0fbaf1c09ab32bc0aecb2280fea08568ecfb10ac301"
  end

  depends_on "libpq"

  def install
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
  end

  def caveats
    <<~EOS
      If installing for the first time, perform the following in order to setup the necessary directory structure:
        pex init
    EOS
  end

  test do
    assert_match "share/pex/packages", shell_output("#{bin}/pex --repo").strip
  end
end
