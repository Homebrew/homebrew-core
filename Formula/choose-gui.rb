class ChooseGui < Formula
  desc "Fuzzy matcher that uses std{in,out} and a native GUI"
  homepage "https://github.com/sdegutis/choose"
  url "https://github.com/sdegutis/choose/archive/1.0.tar.gz"
  sha256 "b1d16c6e143e2a9e9b306cd169ce54535689321d8f016308ff26c82c3d2931bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4c32058d0658cbaa5562974eb2d98149f6adde6b95b91bfb464e8e8e12ff267" => :mojave
    sha256 "bcd4c1c75dad408adfa451351a719ad126e2dadb26a49a4316d7d170ed0c6702" => :high_sierra
    sha256 "5968418e6ee9717884d32f98e840cf02549165a9efc8f42e32549e3ae800c4cd" => :sierra
    sha256 "100c28baee98417c8ce7041956c4a62fe9126b6b36a0f3e186b33500b6b1f2fb" => :el_capitan
    sha256 "fd41325edc44dde3a61c52e310b0faa35314ce9c331b04673f55b6ebd5da28ba" => :yosemite
  end

  depends_on :xcode => :build
  depends_on :macos => :yosemite

  conflicts_with "choose", :because => "both install a `choose` binary"

  def install
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/choose"
  end

  test do
    system "#{bin}/choose", "-h"
  end
end
