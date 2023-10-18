class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.9.1.tar.gz"
  sha256 "50e50ebfa933f285d934d886a0209332df3088c3d25952c994f8bdb349f435ed"
  license "MIT"
  head "https://github.com/toy/blueutil.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a506642507a316aef94d28f7a66e81bff31a8ea12f857976f82263f09d97a9ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d6a6e311741e21dee7f92f27535eb735708c56c837b9ecec932f67df9bccd2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d449cbb55d6bbb8e97a78cf31c95216260388a15da472aa5f792358c036d19f0"
    sha256 cellar: :any_skip_relocation, ventura:        "67e67cff5697cef382650848559d340fa4eca64f1eda16bffde1409f9c6b4a5b"
    sha256 cellar: :any_skip_relocation, monterey:       "44c7ff3ac1835f6cb530480d234153b1d069d6f2bb1de09749676c726fc48ebb"
    sha256 cellar: :any_skip_relocation, big_sur:        "08fff9a9560d90369a06d1aea395b41524621101ec7adf6cee8cfd2565f92c0e"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild "-arch", Hardware::CPU.arch,
               "SDKROOT=",
               "SYMROOT=build",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/blueutil"
  end

  test do
    system "#{bin}/blueutil"
  end
end
