class Physfs < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://icculus.org/physfs/downloads/physfs-3.0.2.tar.bz2"
  sha256 "304df76206d633df5360e738b138c94e82ccf086e50ba84f456d3f8432f9f863"
  license "Zlib"
  head "https://hg.icculus.org/icculus/physfs/", using: :hg

  livecheck do
    url "https://icculus.org/physfs/downloads/"
    regex(/href=.*?physfs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_big_sur: "065d120b86dd681aa4fb20c874456b1fbbae3b8428e2051cea9f49b9da01dceb"
    sha256 cellar: :any, big_sur:       "f2348a828a9f32b6fdb78278c5ecd86c7f7bb4abf27032478b44cd4db6338b0c"
    sha256 cellar: :any, catalina:      "be794e8986be384f98e3d4d14a4fe3830428084febea0caff4bba5c363e890c6"
    sha256 cellar: :any, mojave:        "03f4a5a5ed440e3b39e91af11ac4470f07ce742f844d188bca3e58becfd24f3a"
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
      args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
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
    assert_match "Successful.\nhomebrew", shell_output("#{bin}/test_physfs < test 2>&1")
  end
end
