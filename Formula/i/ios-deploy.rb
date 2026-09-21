class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  url "https://github.com/ios-control/ios-deploy/archive/refs/tags/1.12.2.tar.gz"
  sha256 "2a1e9836192967f60194334261e7af4de2ba72e4047a3e54376e5caa57a1db70"
  license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"]
  head "https://github.com/ios-control/ios-deploy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f11fad9230cc07dbb54eff6e18ddc59d060f7183d720d0fce04827db256956a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c134e86091b997d8edfa187eb7a85cce002930d61d07b4765be958e6f09332bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33846928a8bb9a5f7069629efbc5c0d6fed2723f77b8531b1640f918e79c8b34"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-configuration", "Release",
               "SYMROOT=build",
               "-arch", Hardware::CPU.arch,
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    bin.install "build/Release/ios-deploy"
  end

  test do
    system bin/"ios-deploy", "-V"
  end
end
