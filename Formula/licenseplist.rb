class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.24.2.tar.gz"
  sha256 "227331e52ea46ba11c5890de030b5c4d19a4b3a0c991b102475d4fe5913646bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eeb366c8ae834fd6b0b4d2d349a7ef01a33bcc95aea62950605d8939394cfaf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62b519bf10bb411fcd4f21322eaab87329403a9fbd2d4db9f2d2c98376ee48a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "805ee737dbe224c7835bf300369d1b9acd78677374a1b2da6ae45a075056c6b7"
    sha256 cellar: :any_skip_relocation, ventura:        "914def0736ac988057e2595a7d8911516e36024a1e5c483c029e92fb036ccb4e"
    sha256 cellar: :any_skip_relocation, monterey:       "b3db1929297293290d127a96af4fd4c502235ed73727c893e6853b971e7f392f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b82155f27fa0e8efdd8b676b4c49b9daa83aa8593379456d4d0e3e6e1d4de9e2"
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
    assert_match "None", shell_output("#{bin}/license-plist --suppress-opening-directory")
  end
end
