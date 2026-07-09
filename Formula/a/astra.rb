class Astra < Formula
  desc "Command-Line Interface for DataStax Astra"
  homepage "https://docs.datastax.com/en/astra-cli"
  url "https://github.com/datastax/astra-cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c6103d7de4abea0c5780dfdfbd19945af5d5662d9ce50c03ff7845cd688aca27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb2fac9c17c5f503ac89a005dd905cc2f1f5236a02942e5da751899786901c73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a75c955163c229fdd2f9c0b87491c23a1240fbe3919d710a514b54877ab9737c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40cb7437f75d9ee90c53f2e0ee3ad3e11b88eeeedf5f1e08e59b5fd4f24e09c6"
    sha256 cellar: :any,                 arm64_linux:   "ceebea8e1e6770dd7338da019f8524358906df174b1597c5b730db96f80575aa"
    sha256 cellar: :any,                 x86_64_linux:  "4f3ce475e726fa4af58b9d4ce1a90859711a130f8949f0404f118ca2ec7bc0bd"
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
