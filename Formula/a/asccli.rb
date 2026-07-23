class Asccli < Formula
  desc "App Store Connect CLI to manage apps, versions, and screenshots"
  homepage "https://github.com/tddworks/asc-cli"
  url "https://github.com/tddworks/asc-cli/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "596fd89435de437961ab7bf74ec42bc967ee0b63c11db9b5ca8c6c6a35b18bc0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08761b55f86167151ff1207a0dda39546fe5ad6639c4fe7da33f5e1194aa0460"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d729af4e0d4a679e29bfc89b3ad2f0e533a17ebb2eb3afe44e566f89329a643"
  end

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia

  uses_from_macos "swift" => :build

  def install
    inreplace "Sources/ASCCommand/Version.swift", 'let ascVersion = "0.1.3"', %Q(let ascVersion = "#{version}")
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/asc" => "asccli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asccli --version")

    # `auth check` resolves credentials from the environment and prints the
    # account status as JSON, exercising real functionality with no network
    # access. Throwaway credentials keep the test self-contained.
    ENV["ASC_KEY_ID"] = "TESTKEYID"
    ENV["ASC_ISSUER_ID"] = "00000000-0000-0000-0000-000000000000"
    ENV["ASC_PRIVATE_KEY"] = "-----BEGIN PRIVATE KEY-----\nTEST\n-----END PRIVATE KEY-----"
    status = shell_output("#{bin}/asccli auth check")
    assert_match "keyID", status
    assert_match "issuerID", status
  end
end
