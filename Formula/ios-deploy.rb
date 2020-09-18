class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  url "https://github.com/ios-control/ios-deploy/archive/1.11.2.tar.gz"
  sha256 "bca53cfb2a189e95cc8714d859a8821c3e6d5b9938ac74a7b3b69ea037e38244"
  license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"]
  head "https://github.com/ios-control/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af5fd607db481534ebb05a85a781ef562d18095ad281dcb43739b7cdd9f0645a" => :catalina
    sha256 "c496d357fcf45cb2dbb7b281c588b6b36e72e5f0a2126dca7bf7b311acec26c3" => :mojave
    sha256 "fc27814ad907fcfecaada65a07128eb8fdf4eaaf9e90cf07f2aa483e8fee2a89" => :high_sierra
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
