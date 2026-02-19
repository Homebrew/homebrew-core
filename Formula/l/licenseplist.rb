class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.27.2.tar.gz"
  sha256 "54228c98705db95f081d9d5a579d9f8ae46a50a3c8fb05f1b0285d8ff49e4028"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a74bcabba9657f55148a8a8dc8e646a32da014738835f891d47695107ca0db0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4487fac7309296622e779270445df924d35afed083433aadf820562084ebd71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b7b83caf79ad2dd60db96cba8d4e9a175548f5eba0ba5a8b499e6747fd1aba1"
    sha256 cellar: :any_skip_relocation, sonoma:        "67ae18b0e8a2f2e7baff1be31dca76e6e34d3b435b0d6ea5494b2b04dfccae7e"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/license-plist"
    generate_completions_from_executable(bin/"license-plist", "--generate-completion-script")
  end

  test do
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("#{bin}/license-plist --suppress-opening-directory")
  end
end
