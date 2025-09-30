class IosClassGuard < Formula
  desc "Objective-C obfuscator for Mach-O executables"
  homepage "https://github.com/Polidea/ios-class-guard/"
  url "https://github.com/Polidea/ios-class-guard/archive/refs/tags/0.8.tar.gz"
  sha256 "4446993378f1e84ce1d1b3cbace0375661e3fe2fa1a63b9bf2c5e9370a6058ff"
  license "GPL-2.0-or-later"
  head "https://github.com/Polidea/ios-class-guard.git", branch: "master"

  # The latest version tags in the Git repository are `0.8` (2015-10-14) and
  # `0.6` (2014-08-20) but versions before these are like `3.5` (2013-11-16),
  # `3.4` (2012-11-19), `3.3.4` (2011-09-03), etc. The older releases like `3.5`
  # are wrongly treated as newer but the GitHub repository doesn't mark a
  # "latest" release, so we can only work around this by restricting matching
  # to 0.x releases for now. If the major version reaches 1.x in the
  # future, this check will also need to be updated.
  livecheck do
    url :stable
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "309a61c546e963a18349f50f48dcf782c98fedb310b248b9d2d9936d842d5ec1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4de6dec4f0120a68ac884defc966d1e3ff7da2cae669cccf3b80f72cdf7e7ddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2573d220e15167e7b384badba84c8c81a68e7ec3caf0335182693fac4bacc08e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cfa45ab4d2e9f5ff160c3e88426c890c83d5a87997fff438e04d07cd4d68467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4953b61e871a9935955ce26115619c081b15a5712decba1502b1d50b8d311cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80da4446b7d4838b965d12546d9b10ad777c24c2026248e6d49c415aad3f9771"
    sha256 cellar: :any_skip_relocation, sonoma:         "b63ae8b6898be42e963f77307eab235d553c049a532bc727b628fece3da6c874"
    sha256 cellar: :any_skip_relocation, ventura:        "4864bb18b6e3712c92bede68182d7d8345e35b98da0327b8bbffbfc07891ddee"
    sha256 cellar: :any_skip_relocation, monterey:       "c6ac0f4d85d53a86ee0de247c7119f776506830d4d7d2df26eb2ecebc1fa20f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "159991d0922d6ea71dceb5f97c3024659f70c48fb91c0222186e8c108885db54"
    sha256 cellar: :any_skip_relocation, catalina:       "807b425c949e9a25331abd13967721d6f58d3a1674fcc8175744e713e81ee5d3"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-workspace", "ios-class-guard.xcworkspace",
               "-scheme", "ios-class-guard",
               "-configuration", "Release",
               "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/ios-class-guard"
  end

  test do
    (testpath/"crashdump").write <<~EOS
      1   MYAPP                           0x0006573a -[C03B setR02:] + 42
    EOS
    (testpath/"symbols.json").write <<~JSON
      {
        "C03B" : "MyViewController",
        "setR02" : "setRightButtons"
      }
    JSON
    system bin/"ios-class-guard", "-c", "crashdump", "-m", "symbols.json"
  end
end
