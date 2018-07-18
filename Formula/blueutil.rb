class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.1.0.tar.gz"
  sha256 "446e769e71089a0f40d0d6e6b4808c0c213d97d664bceefd7ef5062e126b80cb"
  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3b44b557c9f1ebfad62a3a8dbe52b64ff5995bfe03003d10ef94fbdf95e6b6c" => :high_sierra
    sha256 "3c5cbdb52c7a528ad23ad9bc99a286ecb03554c71aaf8216ec2a891c16ec6c97" => :sierra
    sha256 "d5af9f8a05af98fa5a5dd6555673a878617573e0036ae42552e93f8758edc814" => :el_capitan
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
