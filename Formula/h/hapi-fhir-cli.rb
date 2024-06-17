class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https://hapifhir.io/"
  url "https://github.com/hapifhir/hapi-fhir/releases/download/v7.2.1/hapi-fhir-7.2.1-cli.zip"
  sha256 "db23929bd797063d02b7e6ee3cea8db6cbdd98f592cb1a7970e387726aef9857"
  license "Apache-2.0"

  # The "latest" release on GitHub is sometimes for an older major/minor, so we
  # can't rely on it being the newest version. However, the formula's `stable`
  # URL is a release asset, so it's necessary to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc329f14a88ef4d84ceba627ff2bc9ab3c9e2a11b0c69bd355d4a8d7d0ad1644"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc329f14a88ef4d84ceba627ff2bc9ab3c9e2a11b0c69bd355d4a8d7d0ad1644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc329f14a88ef4d84ceba627ff2bc9ab3c9e2a11b0c69bd355d4a8d7d0ad1644"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc329f14a88ef4d84ceba627ff2bc9ab3c9e2a11b0c69bd355d4a8d7d0ad1644"
    sha256 cellar: :any_skip_relocation, ventura:        "cc329f14a88ef4d84ceba627ff2bc9ab3c9e2a11b0c69bd355d4a8d7d0ad1644"
    sha256 cellar: :any_skip_relocation, monterey:       "cc329f14a88ef4d84ceba627ff2bc9ab3c9e2a11b0c69bd355d4a8d7d0ad1644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "881142b88632e6afab408cb36dd1d34e445320037222336aa6e6c11ec2378421"
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
