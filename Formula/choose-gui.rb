class ChooseGui < Formula
  desc "Fuzzy matcher that uses std{in,out} and a native GUI"
  homepage "https://github.com/chipsenkbeil/choose"
  url "https://github.com/chipsenkbeil/choose/archive/1.1.tar.gz"
  sha256 "cd921cfa6a7b7e976716c33dd8c800a06f41e88e12e385cd7b1ad5edc63578f2"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "397e6aaafb87524e0baa3f52376814a3d5e5dcf87e909719116742b57a513e4b" => :catalina
    sha256 "b1f2b4a734d1cb3eca56eddac1a0a0c89a1bb1a57f4b3412843e971fd24a01ad" => :mojave
    sha256 "7b5031da703f0297a387fc3f8220e28070b120c91ae4989327164955eedc56d6" => :high_sierra
  end

  depends_on xcode: :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-rust", because: "both install a `choose` binary"

  def install
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/choose"
  end

  test do
    system "#{bin}/choose", "-h"
  end
end
