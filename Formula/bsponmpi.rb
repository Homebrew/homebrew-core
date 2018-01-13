class Bsponmpi < Formula
  desc "Implements the BSPlib standard on top of MPI"
  homepage "https://sourceforge.net/projects/bsponmpi/"
  url "https://downloads.sourceforge.net/project/bsponmpi/bsponmpi/0.3/bsponmpi-0.3.tar.gz"
  sha256 "bc90ca22155be9ff65aca4e964d8cd0bef5f0facef0a42bc1db8b9f822c92a90"
  revision 2

  bottle do
    sha256 "b80c1f5b34b4530ae8cbf402418693e93bd400aa4fb14b998053a3c07024dd35" => :high_sierra
    sha256 "caf59320e2eb005dc2de2daa363d15464e3c83519875503e3a498ab8963bb3aa" => :sierra
    sha256 "10a864ad11ea1145898ae9bcd8897f107c034818e66faf3632d916d51a13a191" => :el_capitan
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
