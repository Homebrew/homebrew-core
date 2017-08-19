class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.60.tar.gz"
  sha256 "29163aed9864a82b4a821d17687e11c05b445f12ab199069b642c4a7ec9ab030"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "34a2b3e7fea22eaeeea6f2f92461233abf52cc0a034894edf7096d03d771e930" => :sierra
    sha256 "a112821a005cdc51e55ae4f8df7e873b712de471ace0d4672e1dd5131a430240" => :el_capitan
    sha256 "be7b58e4327f76a8ca80cf796bd99782c608b13c36d09fdf1a681340416ae2a7" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yaml-cpp" => ((MacOS.version <= :mountain_lion) ? "c++11" : [])

  depends_on :mysql => :recommended
  depends_on :postgresql => :optional

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
