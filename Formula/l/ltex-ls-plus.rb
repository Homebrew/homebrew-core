class LtexLsPlus < Formula
  desc "LTeX+ Language Server: maintained fork of LTeX Language Server"
  homepage "https://ltex-plus.github.io/ltex-plus/"
  url "https://github.com/ltex-plus/ltex-ls-plus/releases/download/18.7.0/ltex-ls-plus-18.7.0-src.tar.gz"
  sha256 "8c5ad69fdbf38061bc511439473b081f2b2db35b0f4788f3516c632345788d2f"
  license "MPL-2.0"
  head "https://github.com/ltex-plus/ltex-ls-plus.git", branch: "develop"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "586bbfa6a458e146577e47aa1dfcadb941a77cd5aba14ba285cf87103ad1f872"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "586bbfa6a458e146577e47aa1dfcadb941a77cd5aba14ba285cf87103ad1f872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "586bbfa6a458e146577e47aa1dfcadb941a77cd5aba14ba285cf87103ad1f872"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fbbdce5a050ae2ae10a79ce7bc250b05b928cd60db5340907b4c74617772388d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fbbdce5a050ae2ae10a79ce7bc250b05b928cd60db5340907b4c74617772388d"
  end

  depends_on "maven" => :build
  depends_on "python@3.15" => :build
  depends_on "openjdk"

  def python = deps.map(&:name).find { |d| d.match?(/^python(@\d+(\.\d+)*)?$/) }

  def install
    ENV.prepend_path "PATH", formula_opt_libexec(python)/"bin"
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["TMPDIR"] = buildpath

    system python3, "-u", "tools/createCompletionLists.py"

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
