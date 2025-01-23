class LtexLsPlus < Formula
  desc "LTeX+ Language Server: maintained fork of LTeX Language Server"
  homepage "https://ltex-plus.github.io/ltex-plus/"
  url "https://github.com/ltex-plus/ltex-ls-plus/archive/refs/tags/18.4.0.tar.gz"
  sha256 "b6855d629d9d8cc9cd03c6f1311b756eea67ae17fe6bfc60e134ea280772abec"
  license "MPL-2.0"
  head "https://github.com/ltex-plus/ltex-ls-plus.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb85f9962c56b5dffa911492c8533b780abc750649f400b5365e854e0b0e28db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4a4a737eac4335b77657dceffcd47a4c4d8401099b4945e143b414e0d41b85b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8176a228b9388cad267fa7dc9c0042e1722eceb0f80c4465cb3ee44b4f9695c"
    sha256 cellar: :any_skip_relocation, sonoma:        "734f9f960525ce8b50d52d631374a83e33343e675eb06dc4626693717c563ffe"
    sha256 cellar: :any_skip_relocation, ventura:       "fd750197b5af6fece30b097f507cd943344f171302ffbdf0a54730104471e5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "840f32395ede074d625b9fefd139a7eece037f31c779216c6838ed1414de652b"
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
