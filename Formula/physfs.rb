class Physfs < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://icculus.org/physfs/downloads/physfs-3.0.2.tar.bz2"
  sha256 "304df76206d633df5360e738b138c94e82ccf086e50ba84f456d3f8432f9f863"
  head "https://hg.icculus.org/icculus/physfs/", :using => :hg

  bottle do
    cellar :any
    sha256 "4b2cf49af5b93bb1d0a0670ceccae84cb26c77a51c4e8230dd792c9da4dc0962" => :mojave
    sha256 "03128f703af35b557fe9e6792dc93dec7b520e7d38a86b782cfdc5e00f850a71" => :high_sierra
    sha256 "9549999aa9862efb9f59fd0448eef8bdfb458cef44367bad6a4fe436584e1977" => :sierra
    sha256 "a8b9f8b640dc1aca30c1505fd738474f71f6122d86216bdaa33e4e3135d97367" => :el_capitan
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
