class Asccli < Formula
  desc "App Store Connect CLI to manage apps, versions, and screenshots"
  homepage "https://github.com/tddworks/asc-cli"
  url "https://github.com/tddworks/asc-cli/archive/refs/tags/v0.18.8.tar.gz"
  sha256 "4cc94c7a7fb49d2837519d5751ab2ace1fa48801b7f68ea0603fc7078f581d69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "106bd0eab1f4e7022f567d36a87786900269b271b69ce8d030fc0aa5810c8628"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "063bc676d9f4f167a1e587bc793ca408db30ffa9ab5d3a3241d0882dbeb4bb51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa85bed0f4f9fc1dfd0802f2ad8a2d38c51ef647e8dbf3353eb2df34cc52decb"
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
