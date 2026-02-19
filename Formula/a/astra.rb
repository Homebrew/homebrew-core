class Astra < Formula
  desc "Command-Line Interface for DataStax Astra"
  homepage "https://docs.datastax.com/en/astra-cli"
  url "https://github.com/datastax/astra-cli/releases/download/v1.0.3/astra-fat.jar"
  sha256 "14b8844409888be54860d14db863d941ee811d16b30d1835241de837627805bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b8a2fb124ec0bfd9c651322166787af76bf8b670a8487d3c5b8a04aa10bfd73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b8a2fb124ec0bfd9c651322166787af76bf8b670a8487d3c5b8a04aa10bfd73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0464d950ede1c9f2937b1203915866115dd441722c481e5ebefc3e58c84472f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5360e7d8d3210259589c025ed04afe1d5ce16a1a316c1d6cbbac384d41ccaf78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0abfeb30c4b6358802d1748786142adf68c1a9390d72866d4e9e7c18bf063bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d820e69d13fa708a00e752d774f97e44021c18cd4d2107b5382616b9017c111f"
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
