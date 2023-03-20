class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.24.3.tar.gz"
  sha256 "3107aa0ef47bda911eba1a609d10eb3d724722264491e873ea5a976bf0f6be25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e8b79aa6d8499ac3878d29cde2bf1255c413c30b1a9689016f20a18055fdc29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe8da00beb253d4bbec4e9f51c94153f7364d434a4c6da8a0c43a9e801508e33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06f63335e2996681e9228ab794772dbd714a9921c57c0d80d5e49f92cbd0d7a7"
    sha256 cellar: :any_skip_relocation, ventura:        "d5981b7403137942db6fbdd3244b9c104f18efb55c0ecb0e78a63b470f8011a0"
    sha256 cellar: :any_skip_relocation, monterey:       "ec670903c01b716275bae82ec870d5d92d124e668e1443fc442f09c6b1fbc9a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3091e742927f40c96428935699fe53c4d1e0830e158bfcb77cddb6b1fc9c1235"
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
