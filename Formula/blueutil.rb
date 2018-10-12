class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.2.0.tar.gz"
  sha256 "ad6c8d15896cbdf5526b85aac57df02f6e00aace178e2f6c5208256f9525e99a"
  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ff16c4be6a2291cda156244f72035cb4d4a9127696559f726f59e8004612308" => :mojave
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
