class Physfs < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://icculus.org/physfs/downloads/physfs-3.0.1.tar.bz2"
  sha256 "b77b9f853168d9636a44f75fca372b363106f52d789d18a2f776397bf117f2f1"
  head "https://hg.icculus.org/icculus/physfs/", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "2158cdbcb7cc8df12d98299500a24d1dbc5a39da58ff1175d24b40c1f3ca958a" => :high_sierra
    sha256 "c06c09374e9691665cd54947ba44b4d1f69be852c03f55148310db882912a3ff" => :sierra
    sha256 "d501cbfdfea7df8ae807f158ad428c02354366a546925a4d042ccb2f9eb30267" => :el_capitan
    sha256 "c53001feb6316238029050dd5f07cdb6a1f17a3c96df9a09b43f709a99b7504e" => :yosemite
    sha256 "c4d372b4db8a7b0ed8019562cebce7ac59b1778c8a88d27a0d6cd508607826b9" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "macbuild" do
      args = std_cmake_args
      args << "-DPHYSFS_BUILD_TEST=TRUE"
      args << "-DPHYSFS_BUILD_WX_TEST=FALSE" unless build.head?
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.txt").write "homebrew"
    system "zip", "test.zip", "test.txt"
    (testpath/"test").write <<~EOS
      addarchive test.zip 1
      cat test.txt
      EOS
    assert_match /Successful\.\nhomebrew/, shell_output("#{bin}/test_physfs < test 2>&1")
  end
end
