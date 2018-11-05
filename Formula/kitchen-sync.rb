class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/1.4.tar.gz"
  sha256 "160449db137cec7fc47a646667c8d977a87c5ff939b2daf6a0f99ffe2e720f30"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2be7a9ccba914e89ef7b798e18b0a17493522daf3a07172e30b1c8d39002f55" => :mojave
    sha256 "8e70fee2dbfc450bfc614c2248227642378537c1b04c915e2c9f7c2b1f187c48" => :high_sierra
    sha256 "8af29ed55e0208c32d20ede87d2d50a70cb719731c2f864e0f5eb5d5ab993c7b" => :sierra
    sha256 "65066a29bde3ea01ec5e38b1631f8eca2f3e1f7e1ac3ff1ce24f06e8b00a136e" => :el_capitan
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
