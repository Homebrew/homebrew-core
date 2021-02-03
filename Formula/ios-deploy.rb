class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  url "https://github.com/ios-control/ios-deploy/archive/1.11.3.tar.gz"
  sha256 "0bdf81aeaef06bbc222fff0cb3a2ec9575593db4027be326a505ae8ece4c424f"
  license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"]
  head "https://github.com/ios-control/ios-deploy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "453f018b6596d17395ccb3ef81874924e322079a3148408146e2532ac82ae75d"
    sha256 cellar: :any_skip_relocation, big_sur:       "33a69d0cdbc5b3a87c4d823c03d5cea427689697f28904487f91d44bce0c156d"
    sha256 cellar: :any_skip_relocation, catalina:      "0547d1ceb2525f68bd73210586875053269dff5bd6731556a836b54f7ed17f86"
    sha256 cellar: :any_skip_relocation, mojave:        "838319b9ff90fe670f92a792ceaa538f382578095ecf3df9f4d8835cd1795893"
    sha256 cellar: :any_skip_relocation, high_sierra:   "914ef6e3a7d365274e8ed2d9415b61df714c5eb41d5c07aaa6a2ac0066ea5bdf"
  end

  depends_on xcode: :build

  def install
    xcodebuild "-configuration", "Release", "SYMROOT=build"

    xcodebuild "test", "-scheme", "ios-deploy-tests", "-configuration", "Release", "SYMROOT=build"

    bin.install "build/Release/ios-deploy"
  end

  test do
    system "#{bin}/ios-deploy", "-V"
  end
end
