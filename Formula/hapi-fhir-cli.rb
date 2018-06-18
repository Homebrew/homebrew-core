class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "http://hapifhir.io/doc_cli.html"
  url "https://github.com/jamesagnew/hapi-fhir/releases/download/v3.4.0/hapi-fhir-3.4.0-cli.tar.bz2"
  sha256 "e2acdcad6a04a5bcc16a3eb5bfeaafaeb1016025c33ff0faeed8a44207319965"

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
    testpath.install resource("test_resource")
    system bin/"hapi-fhir-cli", "validate", "--file", "specimen-example.json",
           "--fhir-version", "dstu3"
  end
end
