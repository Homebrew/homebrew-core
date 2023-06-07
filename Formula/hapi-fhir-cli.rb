class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https://hapifhir.io/"
  url "https://github.com/hapifhir/hapi-fhir/releases/download/v6.6.1/hapi-fhir-6.6.1-cli.zip"
  sha256 "c08e10bd9091511c0a557cc7e7939eeff5828af0b096b8bf6bc53f35caca7fc7"
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
    sha256 cellar: :any_skip_relocation, all: "e776ec5683d1d9c84bd6a3b14f03502342a2143b74ad4fb88148fad26a419118"
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
