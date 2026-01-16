class LtexLs < Formula
  desc "LSP for LanguageTool with support for Latex, Markdown and Others"
  homepage "https://valentjn.github.io/ltex/"
  url "https://github.com/valentjn/ltex-ls/archive/refs/tags/16.0.0.tar.gz"
  sha256 "0cd67495ee4695493fc2a0b37d14146325aa6b9f45d767d16c60abdefdd2dc1d"
  license "MPL-2.0"
  head "https://github.com/valentjn/ltex-ls.git", branch: "develop"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d2dc1612c126df0a99920f428ae300efea2ad97902c12246abb3dbb190ab487"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38ab0f701ab7cfd6103f4dac187e48392fdabea07f476e02aae359c511ceec49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d56ab0b8efa1e3209f83961586067573678919cf40f81fa4614f80768112717"
    sha256 cellar: :any_skip_relocation, sonoma:        "a41867cfd4839ddf272fb8725ebcfd4c4614874dff3b41d4762ff1bd4b179f68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f08e498833b5667fd9fb364169d817272f62dca9d1519da4d7c683c9f9cdc72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fba7ce38f22bf78b00f6c297436db4bf134b1d81c1e9d0fb6352b464dc38fc1f"
  end

  depends_on "maven" => :build
  depends_on "python@3.14" => :build
  # Do not bump, 25+ is not working with an error: java.lang.IllegalArgumentException: 25
  depends_on "openjdk@21"

  def install
    # Fix build with `openjdk` 20.
    # Reported upstream at https://github.com/valentjn/ltex-ls/issues/244.
    inreplace "pom.xml", "<arg>-Werror</arg>", ""

    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"
    ENV["JAVA_HOME"] = Language::Java.java_home(Formula["openjdk@21"].version.major.to_s)
    ENV["TMPDIR"] = buildpath

    system "python3.14", "-u", "tools/createCompletionLists.py"

    system "mvn", "-B", "-e", "-DskipTests", "package"

    mkdir "build" do
      system "tar", "xzf", "../target/ltex-ls-#{version}.tar.gz", "-C", "."

      # remove Windows files
      rm Dir["ltex-ls-#{version}/bin/*.bat"]
      bin.install Dir["ltex-ls-#{version}/bin/*"]
      libexec.install Dir["ltex-ls-#{version}/*"]
    end

    # Fix run with `openjdk` 24.
    # Reported upstream at https://github.com/valentjn/ltex-ls/issues/322.
    envs = Language::Java.overridable_java_home_env("21").merge({
      "JAVA_OPTS" => "${JAVA_OPTS:--Djdk.xml.totalEntitySizeLimit=50000000}",
    })
    bin.env_script_all_files libexec/"bin", envs
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

    got = shell_output("#{bin}/ltex-cli '#{testpath}/test'", 3)
    assert_equal (testpath/"expected").read, got
  end
end
