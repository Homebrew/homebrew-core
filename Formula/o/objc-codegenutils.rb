class ObjcCodegenutils < Formula
  desc "Three small tools to help work with XCode"
  homepage "https://github.com/puls/objc-codegenutils"
  url "https://github.com/puls/objc-codegenutils/archive/refs/tags/v1.0.tar.gz"
  sha256 "98b8819e77e18029f1bda56622d42c162e52ef98f3ba4c6c8fcf5d40c256e845"
  license "Apache-2.0"
  head "https://github.com/puls/objc-codegenutils.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ae4db60ac9757d78ddb5870ca7b39d1de92d4ebda85497ee129e84c26e3f23ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "689a1e289323d187c0e1c89d5fb9c7c1292eb304ae9cbf265303ce701e14407a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd3e144fa7f8cddb59b171eae398fbf10d5d72b98bc0053da553e57213e26c7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d068aa1c50d2e54ceddf2d21a04295829b30e7f3f5504c88364a1bddae5b1a1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5ddfb8ef11849ea3ef38002ca27c492fb9802886ac6cbaf611baa51606de4b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9301f21479af32f32469e8235780f85b74d3a5e7c783fecaef7bb896c734dd55"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e1172fa8991a275968751bcef4020b07f26d410cefe2f4c9efd07a91ff9165a"
    sha256 cellar: :any_skip_relocation, ventura:        "6e60602b0de8383fe7fceca41a4f13dc5bb65c27b1fdd84586e1e9c25bbffb52"
    sha256 cellar: :any_skip_relocation, monterey:       "508fba7003bf8b7e348c96b131558f19bde0a9f08a6096b79a733e1a4d906386"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bd0a4e91d15de385bce1d3ab0ceefefe56d69d461f763373933e64e2d7db992"
    sha256 cellar: :any_skip_relocation, catalina:       "24745ae53d47e15598835ee0538c3f121c48b31b21902b1fd3fab0a8c9886543"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "codegenutils.xcodeproj",
               "-target", "assetgen",
               "-configuration", "Release",
               "SYMROOT=build",
               "OBJROOT=build",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/objc-assetgen"
    xcodebuild "-arch", Hardware::CPU.arch,
               "-target", "colordump",
               "-configuration", "Release",
               "SYMROOT=build",
               "OBJROOT=build",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/objc-colordump"
    xcodebuild "-arch", Hardware::CPU.arch,
               "-target", "identifierconstants",
               "-configuration", "Release",
               "SYMROOT=build",
               "OBJROOT=build",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/objc-identifierconstants"
  end

  test do
    # Would do more verification here but it would require fixture Xcode projects not in the main repo
    system bin/"objc-assetgen", "-h"
    system bin/"objc-colordump", "-h"
    system bin/"objc-identifierconstants", "-h"
  end
end
