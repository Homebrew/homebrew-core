class LtexLs < Formula
  desc "LSP for LanguageTool with support for Latex, Markdown and Others"
  homepage "https://valentjn.github.io/ltex/"
  url "https://github.com/valentjn/ltex-ls/archive/refs/tags/15.2.0.tar.gz"
  sha256 "59209730cb9cda57756a5d52c6af459f026ca72c63488dee3cfd232e4cfbf70a"
  license "MPL-2.0"
  head "https://github.com/valentjn/ltex-ls.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d82d420e9b4eef10741a489adc2b2bee0110bce30b97a9de047c8550f06c7ddf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8107834513e60324f8310d4e2013659e7e7121d322574236ea9d54de124fbc7b"
    sha256 cellar: :any_skip_relocation, monterey:       "1a54a40b5905826e25ea25dbf3762a8f0230dcedd63872d0fdb3f512c41ae60f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ec73bb6429df9a4afccef19dda5a19462481a09a0eb99ddd6b876fdc262626a"
    sha256 cellar: :any_skip_relocation, catalina:       "28ab3330d21ac7e92cb20debadf017c84a09469e7b96d145e64d4c5553cd908a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a87c3dd609bd8bc26b8abc1a60a17dc29323fa6eb678ff31bf068bbed24aaf4"
  end

  depends_on "maven" => :build
  depends_on "python@3.10" => :build
  depends_on "openjdk"

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    ENV["TMPDIR"] = buildpath

    system "python3", "-u", "tools/createCompletionLists.py"

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
