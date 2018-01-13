class Bsponmpi < Formula
  desc "Implements the BSPlib standard on top of MPI"
  homepage "https://sourceforge.net/projects/bsponmpi/"
  url "https://downloads.sourceforge.net/project/bsponmpi/bsponmpi/0.3/bsponmpi-0.3.tar.gz"
  sha256 "bc90ca22155be9ff65aca4e964d8cd0bef5f0facef0a42bc1db8b9f822c92a90"
  revision 2

  bottle do
    sha256 "2d3c362d85b10c9a1bd1b4adc45ac2576abe0a86c15408d20c375bffd9e05494" => :high_sierra
    sha256 "a3b6f8429913d14a42ac9174d9ba30d44f076b9e2b148e7a9409d9b352c66e2f" => :sierra
    sha256 "1142baa7c3a19719304237927f4eb43f8aa405a260c808ef0332c2d8d979b51e" => :el_capitan
  end

  depends_on "scons" => :build
  depends_on "open-mpi"

  def install
    # Don't install 'CVS' folders from tarball
    rm_rf "include/CVS"
    rm_rf "include/tools/CVS"
    scons "-Q", "mode=release"
    prefix.install "lib", "include"
  end
end
