class ChooseGui < Formula
  desc "Fuzzy matcher that uses std{in,out} and a native GUI"
  homepage "https://github.com/chipsenkbeil/choose"
  url "https://github.com/chipsenkbeil/choose/archive/1.1.tar.gz"
  sha256 "cd921cfa6a7b7e976716c33dd8c800a06f41e88e12e385cd7b1ad5edc63578f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "56e072eddbb83e48e719cd4e66b25a3c1b72883d8837310f86b7c12798f9617c" => :catalina
    sha256 "ae372dc62e19e3617efa2cabfab18e55ea2734c2b38dc9960ae3de9ab8935269" => :mojave
    sha256 "3cd12daccad8f8381c3b37f2eb59a48ff2671f18e4cbc539daa1cb6ee606568c" => :high_sierra
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
