class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.27.5.tar.gz"
  sha256 "b02ad561d24154e9c0afab074a03bda52a221d971dae1580dc4044efab59302d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "657ef51fa2829c6139f63abe5c4258d97cf22e9e15212aab7f50f01f73e248e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98072ce44f0f9a9ae03a888440f197f6044952d540fd932780dddffb5da6e4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1416fea17ecc122094d0e464703e32bdd33776fe81b5e8a964f795de3989983e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c8b320a1c90e95a0072d7c369f09d407adbc91dd6dc17d8d3f0b1b4fecc1a33"
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
