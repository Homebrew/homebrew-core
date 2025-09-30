class Mogenerator < Formula
  desc "Generate Objective-C & Swift classes from your Core Data model"
  homepage "https://rentzsch.github.io/mogenerator/"
  url "https://github.com/rentzsch/mogenerator/archive/refs/tags/1.32.tar.gz"
  sha256 "4fa660a19934d94d7ef35626d68ada9912d925416395a6bf4497bd7df35d7a8b"
  license "MIT"
  head "https://github.com/rentzsch/mogenerator.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8efb94ec378cb588e5abe0cb6a1e586a9120fac207896a8b34e64c69992bc24e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a3da7eab4006572e1dedbb58e22b0301a2ddfb272b42c1f2322f326680e577e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8087d13fc33fb3263269a5500831ee3338027c5877c51be48e181fcf472ff46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e3905d64fb52d4543d39ab15d24d091829d22c885e5a423db3ab64d0e9b625d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29159fa7d208a108c0a36a222f7a300151241810eccfef04059a86611dfe41d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51aec3a49207ae357af26a5407494bc88d98027ba06293736b2888ece7b1d71c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dd0fa180a940a69e93f8e6762c25b452b9f87a772c4f1a253da60ae95a2c51f"
    sha256 cellar: :any_skip_relocation, ventura:        "b270d1b6e1f7dd23d8606906587169bf49838f82ab27015b75299f56da9dcf71"
    sha256 cellar: :any_skip_relocation, monterey:       "a9907203474f336c731912e28fad5ec2e912a1e7378d5ba527a7bb3d3b160134"
    sha256 cellar: :any_skip_relocation, big_sur:        "415e0e160574b7b16dff3d0395a7e156894675191c911d09cddf59e1d916571b"
    sha256 cellar: :any_skip_relocation, catalina:       "d62cad0cc94a7b05286fb2a8a2f8e4a4cc3a9b46efa9a391aa9fcb00c381e85e"
  end

  depends_on xcode: :build
  depends_on :macos

  # https://github.com/rentzsch/mogenerator/pull/390
  patch do
    url "https://github.com/rentzsch/mogenerator/commit/20d9cce6df8380160cac0ce07687688076fddf3d.patch?full_index=1"
    sha256 "de700f06c32cc0d4fbcb1cdd91e9e97a55931bc047841985d5c0905e65b5e5b0"
  end

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-target", "mogenerator",
               "-configuration", "Release",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
               "SYMROOT=symroot",
               "OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end

  test do
    system bin/"mogenerator", "--version"
  end
end
