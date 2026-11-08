class Asccli < Formula
  desc "App Store Connect CLI to manage apps, versions, and screenshots"
  homepage "https://github.com/tddworks/asc-cli"
  url "https://github.com/tddworks/asc-cli/archive/refs/tags/v0.18.9.tar.gz"
  sha256 "de373dc9a9c660ed6b504083bb0e46193f94c45ac341ad31259d1c2fbc91c0a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf748fcf5632a84cce5328b9e02a89a186f3d9081039d08420b73fa3da9a7a0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5fbce168997ed4b50ef1b78fa93470286557dabbed4f6f91a19ad990b2a4f421"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ef3034d17e4540c67ab274fef9c91a3eae4d180900ccbf834cf6d5d221757b9"
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
