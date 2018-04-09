class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "http://hapifhir.io/doc_cli.html"
  url "https://github.com/jamesagnew/hapi-fhir/releases/download/v3.3.0/hapi-fhir-3.3.0-cli.tar.bz2"
  sha256 "8342c78598edd9b6509fff0b9cb1de9b277b97f1537342124d1e78523d887d15"

  bottle :unneeded
  depends_on :java => "1.8+"

  resource "test_resource" do
    url "https://github.com/jamesagnew/hapi-fhir/raw/v3.3.0/hapi-fhir-structures-dstu3/src/test/resources/specimen-example.json"
    sha256 "4eacf47eccec800ffd2ca23b704c70d71bc840aeb755912ffb8596562a0a0f5e"
  end

  def install
    inreplace "hapi-fhir-cli", /SCRIPTDIR=(.*)/, "SCRIPTDIR=#{libexec}"
    libexec.install "hapi-fhir-cli.jar"
    bin.install "hapi-fhir-cli"
  end

  test do
    system bin/"hapi-fhir-cli", "validate", "-n", resource("test_resource").fetch.realpath
  end
end
