class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.24.3.tar.gz"
  sha256 "3107aa0ef47bda911eba1a609d10eb3d724722264491e873ea5a976bf0f6be25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "157dad9a9e0729167a3d4dae8fdfea0ee100f2b76c94eea81bdc0bdd3a36c1a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7798aac32ba615f4bdaec6318bb10d9bc34b011e92318b6735202f786d31717c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0e6058b809f415211fe9e2c01431e0e1f65d36f16134244dc766a4a65c850f4"
    sha256 cellar: :any_skip_relocation, ventura:        "d2dd1db4e958254edd7c924c35e4b1b79d36d71f812633bf71b6f7d4e44bbb97"
    sha256 cellar: :any_skip_relocation, monterey:       "88a4473d93fa66b5e3976ee51520ed3cdec6ce79900354844f3e66d7030dbaa8"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e62fd1b18cfd6ec6b966b8d24da5ce9dacc67c0595a30d8eea585338abd8c6e"
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
