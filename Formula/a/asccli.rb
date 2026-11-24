class Asccli < Formula
  desc "App Store Connect CLI to manage apps, versions, and screenshots"
  homepage "https://github.com/tddworks/asc-cli"
  url "https://github.com/tddworks/asc-cli/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "10556835479a6a958fd3278f6c1e5331e161779101f477c6c75aff33ed5f26f4"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "f19bc3be52f874b67b04e4e9b2efa85133a4e6dffbe400d6d21d9b9ec8a5b5e7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6bcd18c09a8975eeaf6aa710d3d519b0b76eb515455d160010d288b493ef5f21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0abf467c1ab406e82651090ec79048be1b8ca93974a7df154f2fa4bdaf1c6987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c4b77d75ede1c9d2ff199758d210a023eb95810a6b5c75b8633b1cafe9807042"
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
