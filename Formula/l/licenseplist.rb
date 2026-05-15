class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.27.8.tar.gz"
  sha256 "7256964f8c19f07b75349bc8022c5ba0e1e4172bf5a38e2ecd259a95f1447aa8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "885935403b9c77263c3f245d3120d3438b8c3b1d5dd4a3366080a3fa08e0c9da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9d266e61b96f7b396be615417abd8cc97b8cf12d57da527e99ddf5b31aae974"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b85ce27e8d4cf127a96f047a660940adc444515d2c92fc1c200e3bb165c2a7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aed95ab5c7d0ce4a39ea79db96606633d6fb29ff2af1063ca81c5081cd615d7"
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
