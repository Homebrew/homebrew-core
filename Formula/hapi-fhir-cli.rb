class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https://hapifhir.io/"
  url "https://github.com/hapifhir/hapi-fhir/releases/download/v6.4.1/hapi-fhir-6.4.1-cli.zip"
  sha256 "a935a8a7cac34fa5300657d55e2669bdf0cb96f87e4ca09ef6967774e528266e"
  license "Apache-2.0"

  # The "latest" release on GitHub is sometimes for an older major/minor, so we
  # can't rely on it being the newest version. The formula's `stable` URL is a
  # release archive, so it's also not appropriate to check the Git tags here.
  # Instead we have to check tags of releases (omitting pre-release versions).
  livecheck do
    url "https://github.com/hapifhir/hapi-fhir/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "64e4d0281d17936c8b2a35f14cc0d7d46bd0fc747c3af2d4e57b6234188f9c4a"
  end

  depends_on "openjdk"

  resource "homebrew-test_resource" do
    url "https://github.com/hapifhir/hapi-fhir/raw/v5.4.0/hapi-fhir-structures-dstu3/src/test/resources/specimen-example.json"
    sha256 "4eacf47eccec800ffd2ca23b704c70d71bc840aeb755912ffb8596562a0a0f5e"
  end

  def install
    inreplace "hapi-fhir-cli", /SCRIPTDIR=(.*)/, "SCRIPTDIR=#{libexec}"
    libexec.install "hapi-fhir-cli.jar"
    bin.install "hapi-fhir-cli"
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    testpath.install resource("homebrew-test_resource")
    system bin/"hapi-fhir-cli", "validate", "--file", "specimen-example.json",
           "--fhir-version", "dstu3"
  end
end
