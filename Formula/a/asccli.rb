class Asccli < Formula
  desc "App Store Connect CLI to manage apps, versions, and screenshots"
  homepage "https://github.com/tddworks/asc-cli"
  url "https://github.com/tddworks/asc-cli/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "1ffd1585a02c9557e2779c28538801e6412d88c29e461e09489321c15076b82b"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "e700c8b2e7527d212a714b7a307d55b495e90e100158bd575e5975d14535e140"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7e86e8aa5c3a0b9e7adef3218c995274fe3713498fa7711227ff48fc59d55b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4c877bc7204f15b522d95422e083c322cc93c1f2904069e87f41deec41aa0f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac200fddfbd606aa448fd104033202cbb46283a100eb1658a261dc0afa38ef43"
  end

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia

  uses_from_macos "swift" => :build

  conflicts_with "asc", because: "both install `asc` binaries"

  def install
    # Fix Swift 6.4 runtime compatibility: https://github.com/apple/swift-collections/issues/733
    inreplace "Package.resolved", <<-OLD, <<-NEW
        "revision" : "a66de878e87ef5a3d5d390e0f6d9002aa5541a43",
        "version" : "1.7.0"
    OLD
        "revision" : "98ef3c98609a1e31b7e157b5b619579001a789d6",
        "version" : "1.7.1"
    NEW
    inreplace "Sources/ASCCommand/Version.swift", 'let ascVersion = "0.1.3"', %Q(let ascVersion = "#{version}")
    system "swift", "build", *std_swift_args
    bin.install ".build/release/asc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asc --version")

    # `auth check` resolves credentials from the environment and prints the
    # account status as JSON, exercising real functionality with no network
    # access. Throwaway credentials keep the test self-contained.
    ENV["ASC_KEY_ID"] = "TESTKEYID"
    ENV["ASC_ISSUER_ID"] = "00000000-0000-0000-0000-000000000000"
    ENV["ASC_PRIVATE_KEY"] = "-----BEGIN PRIVATE KEY-----\nTEST\n-----END PRIVATE KEY-----"
    status = shell_output("#{bin}/asc auth check")
    assert_match "keyID", status
    assert_match "issuerID", status
  end
end
