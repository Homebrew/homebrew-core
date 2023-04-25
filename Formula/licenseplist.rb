class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.24.9.tar.gz"
  sha256 "cb3a5b15f7147954cf74694bf8c235a04945c83093347390bb5175210688d48a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68d66b34571e2155be77537ceb7c56e6401cf183d1b8f5f99418b5e44c790c80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c6d02df32c4d3235779085398bcb7b942e60240a2a18dfe599dfe8c50ff7a60"
    sha256 cellar: :any_skip_relocation, ventura:        "c1196f4f8127a9de5f3591167a8943dc48e4c28c8fc7fb9ec653dfcc3b58583c"
    sha256 cellar: :any_skip_relocation, monterey:       "5ef76254252770d1808b8c4422b4b5509311a9dcf0b12e61b6d1bc7e71596e79"
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
