class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v1.1.0.tar.gz"
  sha256 "a0f19aaffea2b74e00c4a10b06e58bea6598515559267d9081238dce2b4087d8"

  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6c45551ce81e67e02cfb165ad37d344170d1f7fc964a0ed576800d568d888d97" => :sierra
    sha256 "c6599527da984b998b03321634b6facf9ed4bb2f3de35b8c8d4462fb2727bfea" => :el_capitan
    sha256 "287bb35433ac8745719d4f920e1afd0ef75785cd8cb15a17a49214eb82d9e439" => :yosemite
    sha256 "74d6c635e6199da479e819b8b4de8ace42a7cb75deb9d52c37a4373faa7b9690" => :mavericks
    sha256 "fd1e25a79407536f93b4ae5552d30826eef3573aeb44fdd6cb31989bf31ec0d8" => :mountain_lion
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
