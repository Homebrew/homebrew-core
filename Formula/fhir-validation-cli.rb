class FhirValidationCli < Formula
  desc "FHIR command-line validator"
  homepage "https://wiki.hl7.org/Using_the_FHIR_Validator"
  url "https://fhir.github.io/latest-ig-publisher/org.hl7.fhir.validator.jar"
  version "4.1.40-SNAPSHOT"
  sha256 "350ac5a1b258946828fa5ad0bc3784bad427577336bab9a60c382b5470c60a1c"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    inreplace "fhir-validation-cli", /SCRIPTDIR=(.*)/, "SCRIPTDIR=#{libexec}"
    libexec.install "fhir-validation-cli.jar"
    bin.install "fhir-validation-cli"
  end

  test do
    system bin/"fhir-validation-cli"
  end
end
