class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https://hapifhir.io/hapi-fhir/docs/tools/hapi_fhir_cli.html"
  url "https://github.com/jamesagnew/hapi-fhir/archive/v5.0.2.tar.gz"
  sha256 "1eb00d69ad67d8bd419947d0577f714cf7690598e6efadbbd579b811e083c08e"

  bottle :unneeded

  depends_on "openjdk"

  resource "test_resource" do
    url "https://github.com/jamesagnew/hapi-fhir/raw/v5.0.0/hapi-fhir-structures-dstu3/src/test/resources/specimen-example.json"
    sha256 "4eacf47eccec800ffd2ca23b704c70d71bc840aeb755912ffb8596562a0a0f5e"
  end

  def install
    inreplace "hapi-fhir-cli", /SCRIPTDIR=(.*)/, "SCRIPTDIR=#{libexec}"
    libexec.install "hapi-fhir-cli.jar"
    bin.install "hapi-fhir-cli"
    bin.env_script_all_files libexec/"bin", :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    testpath.install resource("test_resource")
    system bin/"hapi-fhir-cli", "validate", "--file", "specimen-example.json",
           "--fhir-version", "dstu3"
  end
end
