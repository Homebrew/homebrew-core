class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.34.5/c-ares-1.34.5.tar.gz"
  sha256 "7d935790e9af081c25c495fd13c2cfcda4792983418e96358ef6e7320ee06346"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d56159131f89594ce18c3ec3c265c35781e7e516386dbc09cc19a670605b2eba"
    sha256 cellar: :any,                 arm64_sonoma:  "c818b5a4764a180d560d9a2779d47d62b670e260c6ce5ccb4ee64adad5d390b7"
    sha256 cellar: :any,                 arm64_ventura: "c4dbf7885c5777eab9778525bfa89d3b986f271d8a3dccdd36ff984f7d8a7419"
    sha256 cellar: :any,                 sonoma:        "69b294fd3ab99c2aa60d1ba250c31f2333e387c64c78ba121a38c0650270724f"
    sha256 cellar: :any,                 ventura:       "f2696223ed541d7ace19e23eb481cb82f780673c9af55335a6848ec69a9f2031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35861d964b56f5e2d8174d62f6a051e9e6a503edb9b9560b390a6ade6b8e4f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "715fad4abf9f1202a1f5da39a69e73adb2bdd994101b84c16e060651340aaab4"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCARES_STATIC=ON
      -DCARES_SHARED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system bin/"ahost", "127.0.0.1"
  end
end
