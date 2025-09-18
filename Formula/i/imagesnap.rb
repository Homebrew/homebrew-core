class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://github.com/rharder/imagesnap"
  url "https://github.com/rharder/imagesnap/archive/refs/tags/0.2.16.tar.gz"
  sha256 "103610515aae71fe1eea6bea15b2b48542f88042515d404fb4d0a18f44120a9a"
  license :public_domain

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0bec4d39310a3a55933d61936845ca15c7b0ce5973f5801ca1377ffc17b87a07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d0088adcce46dada16585280738cedb609b10178e4c192ad9d9b92f92c90b45c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae1001e52ea2fdb7dd9531be39fda237c343b0013f2b7855e9ee1656ae0466b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5673f34fe68a24f689695bfe5c01faedd9040c7947204bff0a69c533bffcd14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b0aaeb3a21d3a74c0f3ac12fb9f6e6283646b9da1acf72cdd1ad257e7bd745b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fdb123fcbab3195ad09621fe4b7c2e1777f93fd00ba6ba07bc0bf8f51bd8301"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0915b8c95b3046c9f05743823899b9e087a14241eab3fde4629d0d6980500ce"
    sha256 cellar: :any_skip_relocation, ventura:        "a3cf2f2513ba875fc96fa062818a3ab9d95aecb1cc706af4cad9f51df4bf31b0"
    sha256 cellar: :any_skip_relocation, monterey:       "7f1c640f6bb51c1b5838639e8165e6156c5e4e48c052639a5b40c593e374bcd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "91158c236f55084e864fe99fe3691e3c1196c9e9e20247d0b754ae73cc2c516c"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "-project", "ImageSnap.xcodeproj", "SYMROOT=build",
"MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/imagesnap"
  end

  test do
    assert_match "imagesnap", shell_output("#{bin}/imagesnap -h")
  end
end
