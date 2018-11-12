class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/1.4.tar.gz"
  sha256 "160449db137cec7fc47a646667c8d977a87c5ff939b2daf6a0f99ffe2e720f30"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1536494b29c6521a170a535b689207cd4dc9cd8783ea7c52148a53ad08314f44" => :mojave
    sha256 "8b67fe069f2a1f9ef38625023cc17a19609bd50a75dd90f6d1b39d77504ea563" => :high_sierra
    sha256 "8aab23fcc57e32a13becc71748eebdb95278228ed436b0b2e7b063274c19092e" => :sierra
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
