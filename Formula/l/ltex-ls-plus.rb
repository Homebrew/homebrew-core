class LtexLsPlus < Formula
  desc "LTeX+ Language Server: maintained fork of LTeX Language Server"
  homepage "https://ltex-plus.github.io/ltex-plus/"
  url "https://github.com/ltex-plus/ltex-ls-plus/releases/download/19.0.0/ltex-ls-plus-19.0.0-src.tar.gz"
  sha256 "639799f55909f59bf1c3802890680f053d173d2b7eca34e6c4bf137b59c5aa80"
  license "MPL-2.0"
  head "https://github.com/ltex-plus/ltex-ls-plus.git", branch: "develop"

  bottle do
    manifest_sha256 "991cc995a80502752c00d8611153e34cd34bc344b1226d58c3ea60d84c569807"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42d9873b3814d9e032f17211c29dc6b3c31a285737fb5f4acc4973a617887979"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42d9873b3814d9e032f17211c29dc6b3c31a285737fb5f4acc4973a617887979"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42d9873b3814d9e032f17211c29dc6b3c31a285737fb5f4acc4973a617887979"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae00dd563b49ee49dad327ce82cb43c3681b96bbda14e40b2f63af39fec29d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ae00dd563b49ee49dad327ce82cb43c3681b96bbda14e40b2f63af39fec29d32"
  end

  depends_on "maven" => :build
  depends_on "python@3.15" => :build
  depends_on "openjdk"

  def install
    ENV.prepend_path "PATH", dep("python").opt_libexec/"bin"
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
