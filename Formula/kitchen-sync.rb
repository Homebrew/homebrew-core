class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.99.1.tar.gz"
  sha256 "895b710f10e9399ce8e49efe1b24ca925b4a62510d817a0e4b60e11c4cefcaf6"
  revision 2
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "7fd3f57cc173fa99cb6e20972c42e513a3dad8efa047805a17aa311e4da673a8" => :high_sierra
    sha256 "a613f1cd8c8cf5d786394bc82c4c0f888808524a1e1c435bcc03bdb7222650d9" => :sierra
    sha256 "b3e0ed03362b2472de1f46d10c718003aeda7334755e721570340765b2601f07" => :el_capitan
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
