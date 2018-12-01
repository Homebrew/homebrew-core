class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/1.7.tar.gz"
  sha256 "c8f393056290de5488d46b975a574638bb33c2d1f697d4902f0d46f662112f86"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c44f936f6ad2b0801035fe95939d9f3f7a5fc2cb60ce3c190ce01cc938feffca" => :mojave
    sha256 "113464f5021617feabe43817fc4a5d5ab0bb5e07805de00f8e8acc5b1ebe1add" => :high_sierra
    sha256 "d74bd7054a4a9fa23610d383936aeb122986ec47af70f269e502b5215d91791f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "mysql-client"
  depends_on "yaml-cpp"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".",
                    "-DMySQL_INCLUDE_DIR=#{Formula["mysql-client"].opt_include}/mysql",
                    *std_cmake_args

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from a://b/ --to c://d/ 2>&1")
    assert_match "Finished Kitchen Syncing", output
  end
end
