class LtexLs < Formula
  desc "LSP for LanguageTool with support for Latex, Markdown and Others"
  homepage "https://valentjn.github.io/ltex/"
  url "https://github.com/valentjn/ltex-ls/archive/refs/tags/15.2.0.tar.gz"
  sha256 "59209730cb9cda57756a5d52c6af459f026ca72c63488dee3cfd232e4cfbf70a"
  license "MPL-2.0"
  head "https://github.com/valentjn/ltex-ls.git", branch: "develop"

  depends_on "maven" => :build
  depends_on "python@3.10" => :build
  depends_on "openjdk"

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    ENV["TMPDIR"] = buildpath
    system Formula["python@3.10"].bin/"python3", "-u", "tools/createCompletionLists.py"
    system "mvn", "-B", "-e", "-DskipTests", "package"
    (buildpath/"build").mkpath
    system "tar", "xzf", "target/ltex-ls-#{version}.tar.gz", "-C", "build"
    # remove Windows files
    rm Dir["build/ltex-ls-#{version}/bin/*.bat"]
    bin.install Dir["build/ltex-ls-#{version}/bin/*"]
    libexec.install Dir["build/ltex-ls-#{version}/*"]
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

    got = `#{bin}/ltex-cli "#{testpath}/test"`
    assert_equal (testpath/"expected").read, got
  end
end
