class LtexLsPlus < Formula
  desc "LTeX+ Language Server: maintained fork of LTeX Language Server"
  homepage "https://ltex-plus.github.io/ltex-plus/"
  url "https://github.com/ltex-plus/ltex-ls-plus/archive/refs/tags/18.5.1.tar.gz"
  sha256 "dbfc83d7e82f5d1f4be9d266248728e11628bd307858adfec20c5dbfda031f90"
  license "MPL-2.0"
  head "https://github.com/ltex-plus/ltex-ls-plus.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "506aba208fad07d55de203b9f5a8d4c587c6a24f1cec7c8ed200b60e2c8fb142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dab59816c40ffc74f2a2f90d051924fbe27bbdcdcfd938fe00b4ce9ddcc5d600"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af2a52c0a38ddeb1c39900a1cc97d196398adf1a66658483df86b0a296ac2771"
    sha256 cellar: :any_skip_relocation, sonoma:        "b43aad065cf4a263cab53ac7d8efaf5c4cca648e9e2e724729aa051fdffe7afd"
    sha256 cellar: :any_skip_relocation, ventura:       "3a31edc7885eca0427172411de04e77c7d81609e04ab8e01f49941059ce89fa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e07514acee82176329bbcb45c652a2c781b3e40becf1fa3724795819b3384fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54de365156f8b7fa5138195e66affa4c46e71482fa345e6a3f33efd8646ed268"
  end

  depends_on "maven" => :build
  depends_on "python@3.13" => :build
  depends_on "openjdk"

  def install
    # Fix build with `openjdk` 20.
    # Reported upstream at https://github.com/valentjn/ltex-ls/issues/244.
    inreplace "pom.xml", "<arg>-Werror</arg>", ""

    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["TMPDIR"] = buildpath

    system "python3.13", "-u", "tools/createCompletionLists.py"

    system "mvn", "-B", "-e", "-DskipTests", "package"

    mkdir "build" do
      system "tar", "xzf", "../target/ltex-ls-plus-#{version}.tar.gz", "-C", "."

      # remove Windows files
      rm Dir["ltex-ls-plus#{version}/bin/*.bat"]
      bin.install Dir["ltex-ls-plus-#{version}/bin/*"]
      libexec.install Dir["ltex-ls-plus-#{version}/*"]
    end

    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"test").write <<~EOS
      She say wrong.
    EOS

    (testpath/"expected").write <<~EOS
      #{testpath}/test:1:5: info: The pronoun 'She' is usually used with a third-person or a past tense verb. [HE_VERB_AGR]
      She say wrong.
          Use 'says'
          Use 'said'
    EOS

    got = shell_output("#{bin}/ltex-cli-plus '#{testpath}/test'", 3)
    assert_equal (testpath/"expected").read, got
  end
end
