class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https://hapifhir.io/doc_cli.html"
  url "https://github.com/jamesagnew/hapi-fhir/releases/download/v4.0.0/hapi-fhir-4.0.0-cli.zip"
  sha256 "fdba98e9ddc295030f9c14bf083fa764a2706adf3f88788d7a021c77c318ca55"

  bottle :unneeded

  depends_on :java => "1.8+"

  resource "test_resource" do
    url "https://github.com/jamesagnew/hapi-fhir/raw/v4.0.0/hapi-fhir-structures-dstu3/src/test/resources/specimen-example.json"
    sha256 "4eacf47eccec800ffd2ca23b704c70d71bc840aeb755912ffb8596562a0a0f5e"
  end

  def install
    inreplace "hapi-fhir-cli", /SCRIPTDIR=(.*)/, "SCRIPTDIR=#{libexec}"
    libexec.install "hapi-fhir-cli.jar"
    bin.install "hapi-fhir-cli"
  end

  test do
    testpath.install resource("test_resource")
    system bin/"hapi-fhir-cli", "validate", "--file", "specimen-example.json",
           "--fhir-version", "dstu3"
  end
end
