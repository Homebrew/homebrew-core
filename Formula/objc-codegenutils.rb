class ObjcCodegenutils < Formula
  desc "Three small tools to help work with XCode"
  homepage "https://github.com/square/objc-codegenutils"
  url "https://github.com/square/objc-codegenutils/archive/v1.0.tar.gz"
  sha256 "98b8819e77e18029f1bda56622d42c162e52ef98f3ba4c6c8fcf5d40c256e845"
  head "https://github.com/square/objc-codegenutils.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24745ae53d47e15598835ee0538c3f121c48b31b21902b1fd3fab0a8c9886543" => :catalina
    sha256 "7a10354a20ef417eeb521c983f4714be063b68e6d74bec7ddf6f72b99d3cbfbe" => :mojave
    sha256 "118c03e858a60fa17c71fbc84fb5a8b9c5f778a0c68531e3df576e1d85d9c91a" => :high_sierra
    sha256 "d7b3d3d26970add3af78b0820f3ef8b5e0290f1b2114f5bf06acddcd8d6bdb34" => :sierra
    sha256 "d7b945db595b07ee5677902586e01002ba555affdcae366f1fcbe919a6013772" => :el_capitan
    sha256 "46d389e6ec12462dfbdd97822ce7c6e8156bbe9fac7a3baf04c20cb1991d9f75" => :mavericks
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "codegenutils.xcodeproj", "-target", "assetgen", "-configuration", "Release", "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/objc-assetgen"
    xcodebuild "-target", "colordump", "-configuration", "Release", "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/objc-colordump"
    xcodebuild "-target", "identifierconstants", "-configuration", "Release", "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/objc-identifierconstants"
  end

  test do
    # Would do more verification here but it would require fixture Xcode projects not in the main repo
    system "#{bin}/objc-assetgen", "-h"
    system "#{bin}/objc-colordump", "-h"
    system "#{bin}/objc-identifierconstants", "-h"
  end
end
