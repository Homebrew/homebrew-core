class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.28.2.tar.gz"
  sha256 "f687b45015a4bbc679b83ee43bfc129c0ecfc4aa6f179b091d5d9fa34dd7ec82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec35c1d92cc5c526b92902610d280869ecf1eea0803ba93d945f744cf3afb1ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1437b7c879cd86fb9701d431e73b60c23628fdefb79e2f9178b15111a4d0cd7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "60ba4f5bdc33e3184a01b2a7d3a1b1ae2849b38123b37db1f8a5c0bac3b95b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4a516ed1e5da5de52b2a56c0425664cffe4da316ae3bc2f9dff1bc7077a9f3e8"
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
