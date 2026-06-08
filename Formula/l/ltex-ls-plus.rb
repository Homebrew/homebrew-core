class LtexLsPlus < Formula
  desc "LTeX+ Language Server: maintained fork of LTeX Language Server"
  homepage "https://ltex-plus.github.io/ltex-plus/"
  url "https://github.com/ltex-plus/ltex-ls-plus/archive/refs/tags/18.6.1.tar.gz"
  sha256 "16fa8c88cea5f579fba4a33c7c89b15a1ed45b9b14dd32a07aee740b3d5506c9"
  license "MPL-2.0"
  head "https://github.com/ltex-plus/ltex-ls-plus.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "508714100a8d794567e14fff608194c917fb851f169c9f991614355d8bc4c1a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25070d0467ec59ff5727af4d5d7347c1af725db987f47a5f1a5932859d07be09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "239e53f81417a897cb4a0774345b6e5d61c085e10625e832e3d1c3110458fab3"
    sha256 cellar: :any_skip_relocation, sonoma:        "995edfc505a74faf0e1fe251a6ecb9676015782ea1583271685f0ddde97813db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1d7996682c4bacd509072aa90c701146c78bc233eb3dc38626012aab37b79f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8890571e3370fc5be4577e4a523a6a5a31314e755282f411f7f2f3247c2a50d0"
  end

  depends_on "maven" => :build
  depends_on "python@3.14" => :build
  depends_on "openjdk"

  def install
    # Fix build with `openjdk` 20.
    # Reported upstream at https://github.com/valentjn/ltex-ls/issues/244.
    inreplace "pom.xml", "<arg>-Werror</arg>", ""

    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"
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
