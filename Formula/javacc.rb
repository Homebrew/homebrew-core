class Javacc < Formula
  desc "Parser generator for use with Java applications"
  homepage "https://javacc.org/"
  url "https://github.com/javacc/javacc/archive/javacc-7.0.11.tar.gz"
  sha256 "68b7f6ad950531f112ca332ea697b56c7b5ad224d1ee132bbe40f297d14f6bd3"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/javacc[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12445b96e8e1456baaded628d43a3ef6dfde345420d224199f9b674627c787ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b30c5474cb749e344cba5f7f4e51d2ebcc37acbea166a4346130108f2031e7ea"
    sha256 cellar: :any_skip_relocation, monterey:       "e85770d22da7247a1ca59ddf462b163826369f2935d841c127c04840c40ae41e"
    sha256 cellar: :any_skip_relocation, big_sur:        "86c6c432c31afc97b7807d317351229e7e1d2e1ee32431f5a9c501521ea1182f"
    sha256 cellar: :any_skip_relocation, catalina:       "53515979909d5bfb4582aa556c12ca881508ba3bfe544534bfbf3f0e026ad0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "177ac116b617ecd9fe564eb0f0960f1393c1039f075d39929823d64b5d91c200"
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
