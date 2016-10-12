class Pex < Formula
  desc "Package manager for PostgreSQL"
  homepage "https://github.com/petere/pex"
  url "https://github.com/petere/pex/archive/1.20140409.tar.gz"
  sha256 "5047946a2f83e00de4096cd2c3b1546bc07be431d758f97764a36b32b8f0ae57"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "93915a607fc3767fccf51c87585b04020f0a20106b690f906050966759f0caef" => :sierra
    sha256 "e70109b6072294b61cbce99ac20daf8a1a522712a1b4f446b698b5291ffca2df" => :el_capitan
    sha256 "afeae97bf3099f85d4a2c3a0ec499fb7b0d596e45ddf90185d8b84d195353c0d" => :yosemite
    sha256 "6280d3f74d9e845da7a274d47e509572192d7dcdc4e7e63230be0fc21d21875b" => :mavericks
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
