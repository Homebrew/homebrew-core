class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  url "https://github.com/ios-control/ios-deploy/archive/1.10.0.tar.gz"
  sha256 "619176b0a78f631be169970a5afc9ec94b206d48ec7cb367bb5bf9d56b098290"
  license "GPL-3.0"
  head "https://github.com/ios-control/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1b6bb2f1d4f8267797575e5fb2d42fcc4aef8798605b7ccd6a0b77362d37203d" => :catalina
    sha256 "14e96bd659a3d47bed7d2e893f9912e5201c04fea54ce56df3642a5037ff621a" => :mojave
    sha256 "f810b5465871c66bc706f06edef3fc1570b1c9e92c806d75742c4998f9c27ee6" => :high_sierra
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-configuration", "Release", "SYMROOT=build"

    xcodebuild "test", "-scheme", "ios-deploy-tests", "-configuration", "Release", "SYMROOT=build"

    bin.install "build/Release/ios-deploy"
  end

  test do
    system "#{bin}/ios-deploy", "-V"
  end
end
