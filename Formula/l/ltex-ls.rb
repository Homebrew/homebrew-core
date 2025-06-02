class LtexLs < Formula
  desc "LSP for LanguageTool with support for Latex, Markdown and Others"
  homepage "https://valentjn.github.io/ltex/"
  url "https://github.com/valentjn/ltex-ls/archive/refs/tags/16.0.0.tar.gz"
  sha256 "0cd67495ee4695493fc2a0b37d14146325aa6b9f45d767d16c60abdefdd2dc1d"
  license "MPL-2.0"
  head "https://github.com/valentjn/ltex-ls.git", branch: "develop"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1881ebd3e1edfa27cf0c9be1b1855e96dfddcd97a97a5c1110e0872dd223f40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd285ef472ccca59e7ada11920cca1bee19ce80a1da8bf1a67802c7085ece1e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "978b9bf4f8cff66fb486159e9c03515dd4c62d3aed644d8a865f92b94dab443e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2863fd23602c84bc942bdc4fdf6a058591364fbf2d49930d85a76d969fc16083"
    sha256 cellar: :any_skip_relocation, ventura:       "60d86af9722182838c19b87d08bfc3b49905c3d3ff06cd5d050c1e49341f18b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5737e77d4ca8e5d3cb76090b2f03fa017ec2eefbea97482d2ba7467adefedbc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab843f15b78c1675d75099d2edfe7a4f2b0f957ba89f401c2db6f5e101894988"
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
      system "tar", "xzf", "../target/ltex-ls-#{version}.tar.gz", "-C", "."

      # remove Windows files
      rm Dir["ltex-ls-#{version}/bin/*.bat"]
      bin.install Dir["ltex-ls-#{version}/bin/*"]
      libexec.install Dir["ltex-ls-#{version}/*"]
    end

    # Fix run with `openjdk` 24.
    # Reported upstream at https://github.com/valentjn/ltex-ls/issues/322.
    envs = Language::Java.overridable_java_home_env.merge({
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
