class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.28.0.tar.gz"
  sha256 "57d53eea12e792213824c56eae2fc763577f97f043945f288c0389ab5363bfcd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11edfae88a7fa250f2b2d2487dbc40e1b263c4a273c54a3d60a7bfdb058cab60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c2701c708e8414227d67577475c92befbc5e3cca8b732c04031168af79c0ca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "158ab1e35ea5e04c71c1a481c26b23a789ca58ed4500cda04c8fc17851be4be3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e76717a115d53914e6782aac2ab36812c2d0a43ab182cc4e0f9d51fee6e04016"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  def install
    system "swift", "build", *std_swift_args
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
