class Aliaspath < Formula
  desc "prints the POSIX path to the original of a Finder alias."
  homepage "https://github.com/rptb1/aliasPath"
  url "https://github.com/rptb1/aliasPath/archive/master.tar.gz"
  version "1.0"
  sha256 "45f586186bc67a8c8dfface8044436354673277a873b347861cb1cca0024ac2b"

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "aliasPath.xcodeproj", "SYMROOT=build"
    bin.install "build/Release/aliasPath"
  end

  test do
    system "#{bin}/aliaspath"
  end
end
