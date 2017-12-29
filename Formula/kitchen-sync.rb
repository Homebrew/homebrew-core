class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.99.1.tar.gz"
  sha256 "895b710f10e9399ce8e49efe1b24ca925b4a62510d817a0e4b60e11c4cefcaf6"
  revision 1
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "08b95b15bfb7d4f5b6bd8afb05115fda8451945404f53491c6ac2663843b2a7f" => :high_sierra
    sha256 "41a60924a8f3132dd1d011bc25cb2a91ac7d28cf3b0843b69b5cb60f0db068e3" => :sierra
    sha256 "3f491f2fea093c3b1b1faa38a9803702857f41f7e65628f5e8b88134570a4fe4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yaml-cpp"
  depends_on "mysql" => :recommended
  depends_on "postgresql" => :optional

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from a://b/ --to c://d/ 2>&1")
    assert_match "Finished Kitchen Syncing", output
  end
end
