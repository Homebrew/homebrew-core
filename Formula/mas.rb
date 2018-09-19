class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas/archive/v1.4.2.tar.gz"
  sha256 "f9a751ff84e6dcbaedd4b2ca95b3ca623c739fd3af0b6ca950c321f2ce840bfe"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb05286adfb9ab0a63a8027391647fb874fa810c07d412505f5bc7911139a3f2" => :mojave
    sha256 "b7585ced3a93d60e95357e93d729913a6f628fda82359e77c6553c2e802c50dc" => :high_sierra
    sha256 "af5be6aa9902d9cfc2aa69dbf313441a7c201463d516face721f900ceae9556b" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

  def install
    xcodebuild "-project", "mas-cli.xcodeproj",
               "-scheme", "mas-cli Release",
               "-configuration", "Release",
               "SYMROOT=build"
    bin.install "build/mas"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
  end
end
