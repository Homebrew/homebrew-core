class LtexLs < Formula
  desc "LSP for LanguageTool with support for Latex, Markdown and Others"
  homepage "https://valentjn.github.io/ltex/"
  url "https://github.com/valentjn/ltex-ls/archive/refs/tags/16.0.0.tar.gz"
  sha256 "0cd67495ee4695493fc2a0b37d14146325aa6b9f45d767d16c60abdefdd2dc1d"
  license "MPL-2.0"
  head "https://github.com/valentjn/ltex-ls.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "906173952c376218818310b186e60bf8b7d3698f579afed9f967ef3ce0966f2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73aa15eb9ccbae4dad9082b36278648f1f2495852c00d149570a810662337d60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33f4777677338470e3aa1f9ac0fc8a90f56d68ad0f677467a7092763de511d40"
    sha256 cellar: :any_skip_relocation, ventura:        "157537c7e8d7833508332982cd95c691664fb5a0790810e2254c0212238984e8"
    sha256 cellar: :any_skip_relocation, monterey:       "349287b0c61db2ece982339d2749283ada14c4016cae8688bb9393c9883f99dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1984213d3c1814418eefbefc2cd313fa234ff1053cef6dfeeb14cdbb705419e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5999bc49069005daea609d4d7a1298650095f802bc4fdf7efb5c3143c4c99838"
  end

  depends_on "maven" => :build
  depends_on "python@3.11" => :build
  depends_on "openjdk"

  def install
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
