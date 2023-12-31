class LtexLs < Formula
  desc "LSP for LanguageTool with support for Latex, Markdown and Others"
  homepage "https://valentjn.github.io/ltex/"
  url "https://github.com/valentjn/ltex-ls/archive/refs/tags/16.0.0.tar.gz"
  sha256 "0cd67495ee4695493fc2a0b37d14146325aa6b9f45d767d16c60abdefdd2dc1d"
  license "MPL-2.0"
  head "https://github.com/valentjn/ltex-ls.git", branch: "develop"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5143777305e63064baf476660aa4f04193481555ec4f6064d7ab162609fae83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8451d3df1c2c862e0891378804e1b141ebcd796c956d95eb48a5f2da65d790f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05ad45e1d55eff3ad2c3bcbd33b820b75d1c2591b13084a4b0a8fee9618dcbfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc962f2d453e6c73bf0f1212d5c238d5ef19d30fc744d6f785f68ae51ce02a70"
    sha256 cellar: :any_skip_relocation, ventura:        "be324e4cc1e537cca541f829854e5cc0ccbf6b4e62f31c3e1c5cf870acb7133c"
    sha256 cellar: :any_skip_relocation, monterey:       "6895ed3a2824794a968d4887408673d84d21de3d877c428c2eac6e3ddcd575aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ecb068a51e5bc4b26f0d64cd60feccf026f6c7b006c34e7a459cd901b1d05ed"
  end

  depends_on "maven" => :build
  depends_on "python@3.12" => :build
  depends_on "openjdk"

  def install
    # Fix build with `openjdk` 20.
    # Reported upstream at https://github.com/valentjn/ltex-ls/issues/244.
    inreplace "pom.xml", "<arg>-Werror</arg>", ""

    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["TMPDIR"] = buildpath

    system "python3.12", "-u", "tools/createCompletionLists.py"

    system "mvn", "-B", "-e", "-DskipTests", "package"

    mkdir "build" do
      system "tar", "xzf", "../target/ltex-ls-#{version}.tar.gz", "-C", "."

      # remove Windows files
      rm Dir["ltex-ls-#{version}/bin/*.bat"]
      bin.install Dir["ltex-ls-#{version}/bin/*"]
      libexec.install Dir["ltex-ls-#{version}/*"]
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

    got = shell_output("#{bin}/ltex-cli '#{testpath}/test'", 3)
    assert_equal (testpath/"expected").read, got
  end
end
