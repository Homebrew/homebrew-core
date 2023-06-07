class Bsponmpi < Formula
  desc "Implements the BSPlib standard on top of MPI"
  homepage "https://sourceforge.net/projects/bsponmpi/"
  url "https://downloads.sourceforge.net/project/bsponmpi/bsponmpi/0.3/bsponmpi-0.3.tar.gz"
  sha256 "bc90ca22155be9ff65aca4e964d8cd0bef5f0facef0a42bc1db8b9f822c92a90"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 catalina:    "f9500519011600313f772afec98331291ce2f90ccb9d6d12bf61ddd05560aace"
    sha256 mojave:      "52b8665fac6efd355024c52473016b3ce2ce832256ba486c0db7ef33f9ddd9ce"
    sha256 high_sierra: "b80c1f5b34b4530ae8cbf402418693e93bd400aa4fb14b998053a3c07024dd35"
    sha256 sierra:      "caf59320e2eb005dc2de2daa363d15464e3c83519875503e3a498ab8963bb3aa"
    sha256 el_capitan:  "10a864ad11ea1145898ae9bcd8897f107c034818e66faf3632d916d51a13a191"
  end

  # SConstruct is written in Python 2 but Homebrew `scons` is built for Python 3
  disable! date: "2022-09-14", because: :does_not_build

  depends_on "scons" => :build
  depends_on :macos
  depends_on "open-mpi"

  def install
    # Don't install 'CVS' folders from tarball
    rm_rf "include/CVS"
    rm_rf "include/tools/CVS"
    system "scons", "-Q", "mode=release"
    prefix.install "lib", "include"
  end
end
