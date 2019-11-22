class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.5.1.tar.gz"
  sha256 "a53f82a5b743199600854bebcb79215d30444b0c7d71e0e41213122ecfe64b47"
  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07d591966a3ec87ad85f578b5ec4883b2c62e473fc39594cd3fefe6e02c24087" => :catalina
    sha256 "d6a015cf0a804d549503fde0db6d7a9a08dd120f69bda40015633e1229addddf" => :mojave
    sha256 "eee630fbd13d0e43655e9f1f5d03431c033aa3b041a934e4ca3ca903ab49538c" => :high_sierra
    sha256 "32e9882536b3e4008522e4cf82475a8c9b94a705892d3812dd1975ba4a8ac36d" => :sierra
  end

  depends_on :xcode => :build

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/blueutil"
  end

  test do
    system "#{bin}/blueutil"
  end
end
