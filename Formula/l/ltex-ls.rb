class LtexLs < Formula
  desc "LSP for LanguageTool with support for Latex, Markdown and Others"
  homepage "https://valentjn.github.io/ltex/"
  url "https://github.com/valentjn/ltex-ls/archive/refs/tags/16.0.0.tar.gz"
  sha256 "0cd67495ee4695493fc2a0b37d14146325aa6b9f45d767d16c60abdefdd2dc1d"
  license "MPL-2.0"
  head "https://github.com/valentjn/ltex-ls.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a362ef0e89ef70637fe32d297181dbaf0ea3c56deb5d429f820af1241948325"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b244f07079c6aaab1a65f648d6ee13266fb1164f7f82f6003a9284e9976d2cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11567aa4c9ea7b6d0516329dc5d527cd1f212b1869a0473456c8a2ec0a902907"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb3a024aedddbde888b77821f76b8c48e4a2648358f669a16881dde500315094"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0fe4a9a3435337d2fa3ffa5659c1a60b7c75f8a7992e50a9ea358b2b29f69a0"
    sha256 cellar: :any_skip_relocation, ventura:        "baa9c3e2989c2664dc853b71bf1b3ccad9b78add83dc44f7bbb6ea9983278c67"
    sha256 cellar: :any_skip_relocation, monterey:       "5e837641af16e424a784e9392f1df5fff22984fd561666e060c6bb4131c9cd0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d69b0d4ba11e0c48d1d7719b126f6240ec15765077cd84be560010bc88b355e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4adccf31620d7eab220663889b631f5b33e52ab7c1e96d1b91dafd732b450baa"
  end

  depends_on "maven" => :build
  depends_on "python@3.11" => :build
  depends_on "openjdk"

  def install
    # Fix build with `openjdk` 20.
    # Reported upstream at https://github.com/valentjn/ltex-ls/issues/244.
    inreplace "pom.xml", "<arg>-Werror</arg>", ""

    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    ENV["TMPDIR"] = buildpath

    system "python3.11", "-u", "tools/createCompletionLists.py"

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
