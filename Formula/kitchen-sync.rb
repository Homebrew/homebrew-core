class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/1.1.tar.gz"
  sha256 "fe50ef8ba9900e1267186b4611afef57ed33a4bce1d79676e8136d9978a162d0"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3835d08971cd59c22947ab0698ad4f5d74a6687fd61d6cada501e9147fabe30" => :high_sierra
    sha256 "407deb35b3980e7c8a14292dc9dfd39ddfb72409eac06c417c3b912dd407c816" => :sierra
    sha256 "3e3aa69b62915179e0dbaa101af8d1ac80eaabb7aca0d9b47747e4b5956aeaf8" => :el_capitan
  end

  deprecated_option "without-mysql" => "without-mysql-client"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yaml-cpp"
  depends_on "mysql-client" => :recommended
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
