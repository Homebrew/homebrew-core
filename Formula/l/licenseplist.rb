class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.28.3.tar.gz"
  sha256 "f5e1482fae8207fec4f11e8b665c0b12f6a8f4e46188c9f1e45af6611a99f360"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "352f7dfb1298a9e044fecd09d28207e47e3d83baea07701c46db530912a26197"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73585c84fdc083e751d9bec8a72992b591a814fd34cb075dbe88f0656f30fdec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6113e8950f5b958465c945859fd52467b8d82d63e2d4735886dfcee05746ef3a"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  # `test do` block looks up the license of a GitHub repository
  allow_network_access! :test

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

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
