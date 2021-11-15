class Javacc < Formula
  desc "Parser generator for use with Java applications"
  homepage "https://javacc.org/"
  url "https://github.com/javacc/javacc/archive/javacc-7.0.10.tar.gz"
  sha256 "656cb9aaed498bcfa5faae40aa8d006760d5431c276fda5bb46cff4225d7c3cc"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/javacc[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c75b5136be3d309ea45af335749e60b9ced4f44fdc02f4c4e766f84254f3ed27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a3acf2460346b3e8fb8fccdff9098574002e3fd927633bf6135a0ab0dd400ce"
    sha256 cellar: :any_skip_relocation, monterey:       "6c8777f66a4c1aff7d0c558f55fa6c261b133bb91db761141f0532b4cb264ddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "81fa6c9cfa14578b76e7baa27ef7ac27ad0038558f4d372ecac6486f2eadc35a"
    sha256 cellar: :any_skip_relocation, catalina:       "54792663583f44565206d4728237a9452859c162cea1e9c7ff782bf33daf6d99"
    sha256 cellar: :any_skip_relocation, mojave:         "f954f391fb286509601a18d87042c3f6d218a7b57414e719cd37786723d71106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75989c6e01cade18da9de70a7e5f3ddae779372b365e9eff2e8dbd78d46ad2cf"
  end

  depends_on "ant" => :build
  depends_on "openjdk"

  def install
    system "ant"
    libexec.install "target/javacc.jar"
    doc.install Dir["www/doc/*"]
    (share/"examples").install Dir["examples/*"]
    %w[javacc jjdoc jjtree].each do |script|
      (bin/script).write <<~SH
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
        exec "${JAVA_HOME}/bin/java" -classpath '#{libexec}/javacc.jar' #{script} "$@"
      SH
    end
  end

  test do
    src_file = share/"examples/SimpleExamples/Simple1.jj"

    output_file_stem = testpath/"Simple1"

    system bin/"javacc", src_file
    assert_predicate output_file_stem.sub_ext(".java"), :exist?

    system bin/"jjtree", src_file
    assert_predicate output_file_stem.sub_ext(".jj.jj"), :exist?

    system bin/"jjdoc", src_file
    assert_predicate output_file_stem.sub_ext(".html"), :exist?
  end
end
