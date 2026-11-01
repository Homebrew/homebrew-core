class Asccli < Formula
  desc "App Store Connect CLI to manage apps, versions, and screenshots"
  homepage "https://github.com/tddworks/asc-cli"
  url "https://github.com/tddworks/asc-cli/archive/refs/tags/v0.18.7.tar.gz"
  sha256 "81164d13f25ea4fee3036be9473d438d228e4837e9a38df307db16d3a9ca6957"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8271ae11571cfcddb73066bf6c518d77797c964c633297cce16b66917fcdb859"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83599637877452d0cee762d2aadbe0fac9f7c4a9bbef64aca4bd33df5b2e5f91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5fecd47228f66335b7b8392510a091d0f607519fdccda1c484c904d9ea78aaf7"
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
