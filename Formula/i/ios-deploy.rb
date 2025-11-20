class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  url "https://github.com/ios-control/ios-deploy/archive/refs/tags/1.12.2.tar.gz"
  sha256 "2a1e9836192967f60194334261e7af4de2ba72e4047a3e54376e5caa57a1db70"
  license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"]
  head "https://github.com/ios-control/ios-deploy.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a265970fdac2b3cbced80ce05eb80cdfeefaf3b8d7b66684b23f8799a4d2d00f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4c69eb7279d465db83c5d996a519fdc0f045338adaef8a92eb426a67f9733ee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d9ac2ff01049d41618a63ef47738fe9e01cf9b77154b9773bde884a42dd31e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c87b96b6692afa7b56724cb2e1a0f1cf1e8065f803266c8d83a7d5623496896"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eae3172eaea91a064b40f05f508d4d4a3d9c18cdba920fec27be57477cfd5ec4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8eddbc577a5cfa12da1fa5e0c6a40ae19f2b20c275326f3e9db6ce95bef0c640"
    sha256 cellar: :any_skip_relocation, sonoma:         "91d82a87a7a1ed736955a407d2fba49053222fd3ab4a4af23123cb6fd6b7ad4b"
    sha256 cellar: :any_skip_relocation, ventura:        "9c9ca5f1ced69ffa9d96409dce25c135560edce0082391f24c84493b8822fd04"
    sha256 cellar: :any_skip_relocation, monterey:       "245e3e9a9334e2fc2ee3e1123493849bbfdec93dd33fad32c45dff32da512e96"
    sha256 cellar: :any_skip_relocation, big_sur:        "b04cc3456def885207da127501db9e3e8defb9b108f1aae2f358e8498d6e8f16"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-configuration", "Release",
               "SYMROOT=build",
               "-arch", Hardware::CPU.arch

    xcodebuild "test",
               "-scheme", "ios-deploy-tests",
               "-configuration", "Release",
               "SYMROOT=build",
               "-arch", Hardware::CPU.arch

    bin.install "build/Release/ios-deploy"
  end

  test do
    system bin/"ios-deploy", "-V"
  end
end
