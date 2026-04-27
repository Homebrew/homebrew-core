class Astra < Formula
  desc "Command-Line Interface for DataStax Astra"
  homepage "https://docs.datastax.com/en/astra-cli"
  url "https://github.com/datastax/astra-cli/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "809f60778dd0cab7e96642712d71d579ac0b856ed8da0abaf0970c5df23f23cb"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a30fd63aeb5014493a8a3c971bd5691bed42dc85107694ed71499c6150b2fb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "584e7be68b0d1a96d518857f5f92ea4416648b9df56fee36028ece7536125b5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc4496618ad0dff14fa2fb9cddec5fde33d32751c5f19c077ef948aad00a1ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3a209a7392c4e5349fb2cf81dbbeee5970329f95675c1f4737f9cef595629cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aee7a9558b268b9f8e716d85581d7ac32f4a546c19a113f619846171deb7d4d"
  end

  depends_on "graalvm" => :build
  depends_on "gradle" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = if OS.mac?
      Formula["graalvm"].opt_libexec/"graalvm.jdk/Contents/Home"
    else
      Formula["graalvm"].opt_libexec
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
