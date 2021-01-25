class Physfs < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://icculus.org/physfs/downloads/physfs-3.0.2.tar.bz2"
  sha256 "304df76206d633df5360e738b138c94e82ccf086e50ba84f456d3f8432f9f863"
  head "https://hg.icculus.org/icculus/physfs/", using: :hg

  livecheck do
    url "https://icculus.org/physfs/downloads/"
    regex(/href=.*?physfs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "9b5564d6d9ced39825e762700cc50c7acfe3c37ef8d3afb89f4d67467b731614" => :big_sur
    sha256 "4c7ece7b4677172dfcf85c0bf0d2b5487252528f6015c12db90cba2e51e59c9d" => :arm64_big_sur
    sha256 "f5c4de02a3b305b0f9e0f1a76856b53542f92b5711ce2724d28797b44220e685" => :catalina
    sha256 "20e3f8285d418477a07926a137dfe7750831bff2399b6b4ce4eb99ba942e1205" => :mojave
  end

  depends_on "cmake" => :build

  uses_from_macos "zip" => :test

  on_linux do
    depends_on "readline"
  end

  def install
    mkdir "macbuild" do
      args = std_cmake_args
      args << "-DPHYSFS_BUILD_TEST=TRUE"
      args << "-DCMAKE_INSTALL_RPATH=#{lib}"
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
