class Javacc < Formula
  desc "Parser generator for use with Java applications"
  homepage "https://javacc.org/"
  url "https://github.com/javacc/javacc/archive/javacc-7.0.8.tar.gz"
  sha256 "7ef354fd9631ae04007fb8f19d100d8af99c429a7bd1627c9222e3334b5682b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "437cd3787126ac8a517e0f293396a3c0a1aff532f189872cf8d8729e47aae414" => :catalina
    sha256 "c24483964d08486d08e3391f1d0229920d22444b93d9ba00665e917446990a0d" => :mojave
    sha256 "f648f62353a5e42238f7d3422debd34c8c33a529e8b3cee6a9a13f97f68719ce" => :high_sierra
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
