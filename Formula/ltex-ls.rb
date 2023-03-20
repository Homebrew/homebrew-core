class LtexLs < Formula
  desc "LSP for LanguageTool with support for Latex, Markdown and Others"
  homepage "https://valentjn.github.io/ltex/"
  url "https://github.com/valentjn/ltex-ls/archive/refs/tags/16.0.0.tar.gz"
  sha256 "0cd67495ee4695493fc2a0b37d14146325aa6b9f45d767d16c60abdefdd2dc1d"
  license "MPL-2.0"
  head "https://github.com/valentjn/ltex-ls.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "113e449a798528e7444d99320dbca9177b30c6291d1bb206ef08c0e1451d7a53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4fd9432edbbaa67a5c05d2ac81fd56035b97a74917eed44c258e693995445bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70c1dbb0da6a78d0f4688b52b9b44f3516d7e893e8bcd2e71c0922d00dd3476d"
    sha256 cellar: :any_skip_relocation, ventura:        "be491b7ac074c6ac2f0531023f3e8ad0150f5b1494fec1d8e00883063b4fb589"
    sha256 cellar: :any_skip_relocation, monterey:       "2f6444470a34752b47e06032f595d3d2265f197991061357cdb39443bc8a777c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f63394d07116dcd045e6bc15f9bf8005a6a897ffa1cbb84fff153dc5d8a0b73d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff16cbe22c436d3b9043f961279704db676bf7bda1c50435875dc25d0432a156"
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
