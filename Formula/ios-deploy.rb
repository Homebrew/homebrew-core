class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  url "https://github.com/ios-control/ios-deploy/archive/1.11.4.tar.gz"
  sha256 "52aa0a5985fb5638c9b35351f7380b416651d172a460ca991fc02d1ae84611f6"
  license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"]
  head "https://github.com/ios-control/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33a69d0cdbc5b3a87c4d823c03d5cea427689697f28904487f91d44bce0c156d" => :big_sur
    sha256 "453f018b6596d17395ccb3ef81874924e322079a3148408146e2532ac82ae75d" => :arm64_big_sur
    sha256 "0547d1ceb2525f68bd73210586875053269dff5bd6731556a836b54f7ed17f86" => :catalina
    sha256 "838319b9ff90fe670f92a792ceaa538f382578095ecf3df9f4d8835cd1795893" => :mojave
    sha256 "914ef6e3a7d365274e8ed2d9415b61df714c5eb41d5c07aaa6a2ac0066ea5bdf" => :high_sierra
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
