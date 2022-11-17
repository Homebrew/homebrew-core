class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"]
  head "https://github.com/ios-control/ios-deploy.git", branch: "master"

  stable do
    url "https://github.com/ios-control/ios-deploy/archive/refs/tags/1.12.0.tar.gz"
    sha256 "49f4835e365f6c5c986af3f4bd5c1858c1a1d110aa7f9cf45649c3617911c508"

    # fix build failure, remove in next release
    patch do
      url "https://github.com/ios-control/ios-deploy/commit/24c9efbd43f2acd25c0f3e85137e29ec3c1654cf.patch?full_index=1"
      sha256 "efc223ca219fb64c06155b1675a8a81d57ee42c18ff210c070d8d6f37c893b07"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96bca7e7f751379de2241853b9cf2e0fe1f518493e9365c31116fb3a309c21ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9afe8fd08f085f05104499bee9dd6e79110cf9f63fd7be57fc5c28628af9a09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d472b334895a1863262cfdceaf777ab9a6c675c265e4d83265ae3c2d9b25793"
    sha256 cellar: :any_skip_relocation, ventura:        "ffd40c6b9216bfd90adf4c1cfe7aafd263e79b795794bded1dd05eeb986a78cb"
    sha256 cellar: :any_skip_relocation, monterey:       "eb4951c90cae9df4a16a5c20cd24393647899eebef8fb4f313f9eb999a28230e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4920f28ef96b15c91cbc7e0d84232f4756dd4ecb50bc5fc4b47cb6e5137ab36a"
    sha256 cellar: :any_skip_relocation, catalina:       "6f6b852da9e2caf687adec64fbf683d2be92e1c04c00e5fb93db6faca92ed22c"
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
    system "#{bin}/ios-deploy", "-V"
  end
end
