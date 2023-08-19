class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.24.10.tar.gz"
  sha256 "89cecba2612c991d6ecbf3781999f57eb47e7ed2c99549cf8fa874afa31b7991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3604e39c4270ae3055df5589306ddd54ed3fb821848cfc6fa42185b5af5087b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5fca50feb2f2361dbf1737b564be3ed673db43c732adc1394520769af8e64bb"
    sha256 cellar: :any_skip_relocation, ventura:        "5ef64b2f632ac648ad97dcadab34b7bead4aecddb5b7ccdd0db9ae86a86838bb"
    sha256 cellar: :any_skip_relocation, monterey:       "f13cbbf48c0e1e52616187f527be546242898d2c6456df77f09290abf3658095"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("#{bin}/license-plist --suppress-opening-directory")
  end
end
