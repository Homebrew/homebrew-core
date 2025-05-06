class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.27.1.tar.gz"
  sha256 "6faabde2834f2d45f6467ed34d404a8ee73dcb505f00a8f1a84c55b369a7029b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "455aa974e950c7e0f19ea4ae8dc0666a01b663b07eea474fcb515cc20e3cad99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ccc055b2f25c05d5f8f0c236530382463e98ea751b1136958ba8460d7fa7aa7"
    sha256 cellar: :any,                 arm64_ventura: "d5bb44b8bacf9ef76ab5b2f97ba75586d76c5096c60617547ea76c664ec6e6b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "88ad0ab2826148ae09d5157e172c44585d974eed16be9c9829bd2453b2dee227"
    sha256 cellar: :any,                 ventura:       "b2ff6995c345cbcc2eee53878b7740b910c88a3551504f4560ebd9c8c64e8d74"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/license-plist"
  end

  test do
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("#{bin}/license-plist --suppress-opening-directory")
  end
end
