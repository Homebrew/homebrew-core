class Astra < Formula
  desc "Command-Line Interface for DataStax Astra"
  homepage "https://docs.datastax.com/en/astra-cli"
  url "https://github.com/datastax/astra-cli/releases/download/v1.0.2/astra-fat.jar"
  sha256 "21404f4d26b9608a85d8cd65d52c93555bc6030398cb1208b6d2e7ee07aed542"
  license "Apache-2.0"

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
