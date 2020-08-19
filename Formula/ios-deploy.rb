class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  url "https://github.com/ios-control/ios-deploy/archive/1.11.1.tar.gz"
  sha256 "638c90ae7ec71bc89ed0f2e9a464b9db8f2b312a20802c782873f82675d41048"
  # license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"], waiting for next brew release
  head "https://github.com/ios-control/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "46c878ef32dd500901a6d12859f467d5bf55851ff5b26d508d140016a3c9e834" => :catalina
    sha256 "b35fa700f91ecd1738ede8fb2a149c839f57841e831f8ac0971e42d4ae32d741" => :mojave
    sha256 "19485d858ef8be95dff22feeb01e8367792caa8919cc8289d0893bd49640b3aa" => :high_sierra
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
