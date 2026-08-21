class Astra < Formula
  desc "Command-Line Interface for DataStax Astra"
  homepage "https://docs.datastax.com/en/astra-cli"
  url "https://github.com/datastax/astra-cli/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "698c14212df3301065bffe3c39744e51645c03c04f76223d251b8b9cdf0198c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0af51198f7cb0e04eb8a82b73bd8210746b9d8618f59675a61c05d21f444c804"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3871c579122f694c4b7fd092412c09d3aee0291382ab665b5b6ca4a3e61f49a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27f3569c725abf2623eff52019c726c0bda81a63d33acd48b2ff7c49965e5d16"
    sha256 cellar: :any,                 arm64_linux:   "7c06c6ba76169e8be1c0854e306433b0352f4982692072b40e915ad5e68052ed"
    sha256 cellar: :any,                 x86_64_linux:  "190510803806e777b6f3bbafcb3e3ad67807385cc76e2732819036cb211a09cf"
  end

  depends_on "graalvm" => :build
  depends_on "gradle" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = if OS.mac?
      formula_opt_libexec("graalvm")/"graalvm.jdk/Contents/Home"
    else
      formula_opt_libexec("graalvm")
    end

    native_image_env = ENV.keys.grep(/^HOMEBREW_/).map { |key| "-E#{key}" }
    ENV.prepend "NATIVE_IMAGE_OPTIONS", native_image_env.join(" ")

    (buildpath/"src/main/resources/static.properties").append_lines "cli.via-brew=true"
    system "gradle", "nativeCompile", "-Pprod", "--exclude-task", "test", "--no-daemon"

    bin.install "build/native/nativeCompile/astra"

    generate_completions_from_executable bin/"astra", "compgen", shell_parameter_format: :none, shells: [:bash, :zsh]
  end

  test do
    ENV["ASTRARC"] = "/a/b/c"
    ENV["ASTRA_HOME"] = testpath
    assert_equal "/a/b/c",
      shell_output("#{bin}/astra config path -p").strip

    ENV["ASTRARC"] = "/x/y/z"
    assert_match "Error: The default configuration file (/x/y/z) does not exist.",
      shell_output("#{bin}/astra db list 2>&1", 2)

    assert_match "DbNamesCompletion_arr",
      shell_output("#{bin}/astra compgen")
  end
end
