class Mogenerator < Formula
  desc "Generate Objective-C code for Core Data custom classes"
  homepage "https://rentzsch.github.io/mogenerator/"
  url "https://github.com/rentzsch/mogenerator/archive/1.31.tar.gz"
  sha256 "219186cbd37a299e91c2b036b6dfd9f25ddb971857368edcb0f3e1c7fada7e2a"

  head "https://github.com/rentzsch/mogenerator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "19c0ec0b7f39deec9c99f4ede5ae1538acad0b3768db7b0557e15660efb41789" => :sierra
    sha256 "eb94c192bb659183c72f970f1230948ce875ed49b53f0e7bb540660e7dae2353" => :el_capitan
    sha256 "ceedcaabd71b51758c0b03e4b14be0f228e030af83651ad6f774c08d5910123b" => :yosemite
  end

  depends_on :xcode => :build
  depends_on :macos => :yosemite

  def install
    xcodebuild "-target", "mogenerator", "-configuration", "Release", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
