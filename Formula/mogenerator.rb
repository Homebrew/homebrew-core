class Mogenerator < Formula
  desc "Generate Objective-C code for Core Data custom classes"
  homepage "https://rentzsch.github.io/mogenerator/"
  url "https://github.com/rentzsch/mogenerator/archive/1.30.1.tar.gz"
  sha256 "44ee6c61209a53a78914cd9545263bc685f8b3ea061adeeb9fdeeeb68f94fb52"

  head "https://github.com/rentzsch/mogenerator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e01356fac8716f29cf5662b06da3f238147d7320da1ca4ec560284b207fdd37d" => :el_capitan
    sha256 "621065a5fec651c0f3a4ef46ab8b5064d74f6cb4b9c2357a809f2cef6281d216" => :yosemite
  end

  depends_on :xcode => :build
  depends_on :macos => :yosemite

  def install
    xcodebuild "-target", "mogenerator", "-configuration", "Release", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
