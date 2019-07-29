class Pex < Formula
  desc "Package manager for PostgreSQL"
  homepage "https://github.com/petere/pex"
  url "https://github.com/petere/pex/archive/1.20140409.tar.gz"
  sha256 "5047946a2f83e00de4096cd2c3b1546bc07be431d758f97764a36b32b8f0ae57"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "427b8a701474aa879f8728ec463d3f20aad7c67f7b0ce330245015ec2830806a" => :mojave
    sha256 "ed1429f15df1e663735f27b1c7660e289953494b84a84bdd919a7eb077576a72" => :high_sierra
    sha256 "ed1429f15df1e663735f27b1c7660e289953494b84a84bdd919a7eb077576a72" => :sierra
    sha256 "ed1429f15df1e663735f27b1c7660e289953494b84a84bdd919a7eb077576a72" => :el_capitan
  end

  depends_on "postgresql"

  def install
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
  end

  def caveats; <<~EOS
    If installing for the first time, perform the following in order to setup the necessary directory structure:
      pex init
  EOS
  end

  test do
    assert_match "share/pex/packages", shell_output("#{bin}/pex --repo").strip
  end
end
