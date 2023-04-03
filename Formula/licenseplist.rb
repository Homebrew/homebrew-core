class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.24.7.tar.gz"
  sha256 "f391f847b79a67c5271c1288e9984a397f8cbb7d9e5337225278db1950ddd0c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "009e59a9fa7efa8af43ef52dde844754ae8df91a4039af8e94db4d0946059177"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ab4ecd2f8f9423963680bdf8747cf1896df294d67c3db982885aab8efdfed7f"
    sha256 cellar: :any_skip_relocation, ventura:        "7879e1ae31c740d18f201e6d18f47291002c4d996a21fadcce1c3148c71b4aaa"
    sha256 cellar: :any_skip_relocation, monterey:       "042c4c268e1a23bc43a123371361cb9202bd5a41ef41f83b5d9507b42d664b7e"
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
