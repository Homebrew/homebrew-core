class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/1.0.tar.gz"
  sha256 "a25bfbf56b4a49f69521ed57d290ad8cb7e190a9e354115bd86e41e9a80cd031"
  revision 1
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "4b5f21c87624bfc140016556df78770c1172bfb6613afd36a3ffab7e20f0b4de" => :high_sierra
    sha256 "b05d1f38afb43db48a15f9247418bf5696922b870fe2bafe7cc9de0c88d8b806" => :sierra
    sha256 "927f44f22aeb09e28a04b7511440e75379748516e99b50333ad8059817c462d5" => :el_capitan
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
