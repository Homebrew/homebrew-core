class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https://hapifhir.io/"
  url "https://github.com/hapifhir/hapi-fhir/releases/download/v7.2.2/hapi-fhir-7.2.2-cli.zip"
  sha256 "95e7fec7187b41df572234e76cda905dc73d71a88d9c78a57681ac3dffd17ca8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9cce37f4d6f332b1d3fc2d275ce9bc3346ef7b35032df6648ff11dc9ce4994a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9cce37f4d6f332b1d3fc2d275ce9bc3346ef7b35032df6648ff11dc9ce4994a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9cce37f4d6f332b1d3fc2d275ce9bc3346ef7b35032df6648ff11dc9ce4994a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9cce37f4d6f332b1d3fc2d275ce9bc3346ef7b35032df6648ff11dc9ce4994a"
    sha256 cellar: :any_skip_relocation, ventura:        "e9cce37f4d6f332b1d3fc2d275ce9bc3346ef7b35032df6648ff11dc9ce4994a"
    sha256 cellar: :any_skip_relocation, monterey:       "e9cce37f4d6f332b1d3fc2d275ce9bc3346ef7b35032df6648ff11dc9ce4994a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b67824bf820f01e0e5d76e95761c24599ae2ca57003564c490505c58141807c"
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
