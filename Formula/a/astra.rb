class Astra < Formula
  desc "Command-Line Interface for DataStax Astra"
  homepage "https://docs.datastax.com/en/astra-cli"
  url "https://github.com/datastax/astra-cli/releases/download/v1.0.2/astra-fat.jar"
  sha256 "21404f4d26b9608a85d8cd65d52c93555bc6030398cb1208b6d2e7ee07aed542"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05f012277104085caa7577de3031dbef897ad77c6b3ead1c77cdd099310cd4aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea64e938f064b8efb6ace7cd542c56858351185056536f43d040761124066a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20c0b8598d8853819157889912cf431f3df76448b8cb84fef1d269fc2cf4b639"
    sha256 cellar: :any_skip_relocation, sonoma:        "05f012277104085caa7577de3031dbef897ad77c6b3ead1c77cdd099310cd4aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "276aa74f753a696fa6538de95ec2351ae2612d9323e2445d40990296baa7a0dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "276aa74f753a696fa6538de95ec2351ae2612d9323e2445d40990296baa7a0dc"
  end

  depends_on "openjdk"

  def install
    libexec.install "astra-fat.jar"

    (bin/"astra").write_env_script Formula["openjdk"].opt_bin/"java",
      "--enable-native-access=ALL-UNNAMED -Dcli.via-brew -jar #{libexec}/astra-fat.jar",
      JAVA_HOME: Formula["openjdk"].opt_prefix

    chmod "+x", bin/"astra"

    generate_completions_from_executable bin/"astra", "compgen", shell_parameter_format: :none, shells: [:bash, :zsh]
  end

  test do
    ENV["ASTRARC"] = "/a/b/c"
    assert_equal "/a/b/c",
      shell_output("#{bin}/astra config path -p").strip

    ENV["ASTRARC"] = "/x/y/z"
    assert_match "Error: The default configuration file (/x/y/z) does not exist.",
      shell_output("#{bin}/astra db list 2>&1", 2)

    assert_match "DbNamesCompletion_arr",
      shell_output("#{bin}/astra compgen")
  end
end
