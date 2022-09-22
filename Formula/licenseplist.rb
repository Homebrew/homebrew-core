class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.23.3.tar.gz"
  sha256 "959ceba01012ccda55b2b5641df8684334bff1ee643faf39af80fbc72f3a2098"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2f7c4a320808606bdf961df95bfc76edeb312aaa59b7e1ee69a5c33c2cd5759"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9aa8a67a2afa0679a5ef003ca87fe00186bfdea451f429d157c0742ca77b119"
    sha256 cellar: :any_skip_relocation, monterey:       "1ba7caa7a85d1180f6f1324268a095a21c94e2e04b37241c19c1431821b9c1b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d12059cb4c4bfa51df8b8512defd0a2bcf48b2bfc11d2fc78e6d546a51031ca"
  end

  depends_on xcode: ["13.0", :build]
  depends_on :macos
  uses_from_macos "swift" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("license-plist --suppress-opening-directory")
  end
end
