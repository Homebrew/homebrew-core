class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.24.1.tar.gz"
  sha256 "e2b3e2f634310ef33f64feeffb1bb08973fafcf9bb69382ea2aa0d8b8344d5fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f28689d869f14bbb805f185534c07cbd9f9077bc8138a91223faa7d374b6a89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec02edd588d04760511dbe68588d342995896dc269c91920bb871e77ffebc196"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee9275ac68ddc69538a9fb8e6ce2261220bc56e2654bf444ef33fcf00575006a"
    sha256 cellar: :any_skip_relocation, ventura:        "358eb1ce5cce2fe3c412b4d65ebdb1929ce6855f4ee2dd20d6be9fa427c57bdc"
    sha256 cellar: :any_skip_relocation, monterey:       "c7ec27a0485dc26db6f82e0530e61f2c7247e27e7ced6d90e99d74720483ec02"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5472f9f6f7b2d8e3fc9ccd8dfe8b488799f3666b29c7895a5e57976f0cb5e64"
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
