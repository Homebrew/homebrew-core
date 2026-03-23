class Astra < Formula
  desc "Command-Line Interface for DataStax Astra"
  homepage "https://docs.datastax.com/en/astra-cli"
  url "https://github.com/datastax/astra-cli/releases/download/v1.0.4/astra-fat.jar"
  sha256 "21ba898598da0ed3b57d209eea2ce18df2367f53a4b2cb549d8bb7db08cc2294"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63abb48bd1b0a501230708ff114e7972c10cc0b2dd052473dfae0fbc17ed8ffb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b1052e8f2c3fef0ad0a149ccadb7e97dd616902176be155515981af6ebc0f86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6275bd6d3284f07955a4794e3e49c1df8a0a744d17ea94d9cbbf25057b69d3c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6275bd6d3284f07955a4794e3e49c1df8a0a744d17ea94d9cbbf25057b69d3c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1320d2fcc71f6789eba8b974127bff7f0d925c9a10f1e466854f5a2e4d88b657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a119bcef3ab863320bd967812e1c4c9d88a6c73360143ef65447558ff82ea69"
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
