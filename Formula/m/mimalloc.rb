class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.2.8.tar.gz"
  sha256 "68163666575518c213a6593850099adce3863b340ca2751103dbd1f253664e05"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc6f9b1db6effe64908a85e46ecfb03341acf1352ba7a3c83308bf1af3e50ffb"
    sha256 cellar: :any,                 arm64_sequoia: "17c926d79dcead2314f91f205bf85f37114f909a6e6a838840ad923552df2731"
    sha256 cellar: :any,                 arm64_sonoma:  "6f87b08db6ad3e794a298afdb385eece6ff31068f3b1211916404b262b5752ac"
    sha256 cellar: :any,                 sonoma:        "4b586ead845fadaff26fea75596f2115cd2f4f9184184c82487e4bff9d4bfeb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84ccd64fddcd740fd1d8e19b4dc36af100b80cd8210d8ba0bd667605c749029e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0554e2b09e732858ef460e41a80216e3fc2937711aa244a543e6735991a11557"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match(/pages\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end
