class LtexLsPlus < Formula
  desc "LTeX+ Language Server: maintained fork of LTeX Language Server"
  homepage "https://ltex-plus.github.io/ltex-plus/"
  url "https://github.com/ltex-plus/ltex-ls-plus/archive/refs/tags/18.7.0.tar.gz"
  sha256 "9a0592782a4a1509cab20764eac893461b438e9f857799db3eafbdd66812d7a3"
  license "MPL-2.0"
  head "https://github.com/ltex-plus/ltex-ls-plus.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8013959507853e3325864ad022c71a31055252ffd18bdb53c86d9e364515ecb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8013959507853e3325864ad022c71a31055252ffd18bdb53c86d9e364515ecb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8013959507853e3325864ad022c71a31055252ffd18bdb53c86d9e364515ecb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8013959507853e3325864ad022c71a31055252ffd18bdb53c86d9e364515ecb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60970829e51e227dc23161582b0b72b383fddcf96e3f3bce5480cbdf837029b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60970829e51e227dc23161582b0b72b383fddcf96e3f3bce5480cbdf837029b1"
  end

  depends_on "maven" => :build
  depends_on "python@3.14" => :build
  depends_on "openjdk"

  def install
    # Fix build with `openjdk` 20.
    # Reported upstream at https://github.com/valentjn/ltex-ls/issues/244.
    inreplace "pom.xml", "<arg>-Werror</arg>", ""

    ENV.prepend_path "PATH", formula_opt_libexec("python@3.14")/"bin"
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["TMPDIR"] = buildpath

    system "python3.14", "-u", "tools/createCompletionLists.py"

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
