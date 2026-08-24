class Astra < Formula
  desc "Command-Line Interface for DataStax Astra"
  homepage "https://docs.datastax.com/en/astra-cli"
  url "https://github.com/datastax/astra-cli/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "b252b461004d27c3331e456cb7a47f02c9b566025c61c74d8778fcb55f4508df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "549b8ebf33b3fa3cc353f80e7b7714c7f9880ab07e83db305ae9e4c19728e185"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5731e1cf9b66d10c0e812b4b573538d88b8b006697b310e0844a19bc703cfc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24d51c01170b31935864a52e5c64cc8c38c3bf0b813bf7829b1938735c59ed6c"
    sha256 cellar: :any,                 arm64_linux:   "7899b1bccb71899737a9baa9b3a881cedb75f3d03c5b0c8cf747412693298c68"
    sha256 cellar: :any,                 x86_64_linux:  "690a2d57a00c5e640b3e56a13d539f8c67c53dab49daba5cf0054a2ff7dc3120"
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

    # `astra compgen` writes an upgrade-notifier file under `ASTRA_HOME`, which defaults to `$HOME`
    ENV["ASTRA_HOME"] = buildpath

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
