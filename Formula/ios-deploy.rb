class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  url "https://github.com/ios-control/ios-deploy/archive/1.11.0.tar.gz"
  sha256 "714f0391bd5b5909f666cf9f11a85316ba8c4dfe48b6415e3c5990039b9b7c65"
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
