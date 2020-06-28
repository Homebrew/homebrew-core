class Javacc < Formula
  desc "Parser generator for use with Java applications"
  homepage "https://javacc.org/"
  url "https://github.com/javacc/javacc/archive/javacc-7.0.9.tar.gz"
  sha256 "8f16103c741761f8fb6b9caef1c941ba9dd2d0cca01fd0bee26cdadf19a5af14"

  bottle do
    cellar :any_skip_relocation
    sha256 "a52693a4ca5d13098e48f4325cb97504d1e9637c02b4bacca815c8ed123e585a" => :catalina
    sha256 "c908d04a9ae71a75b685f437c6f3810aa5ac909682a2bba7d3ba72c0ea272871" => :mojave
    sha256 "2492365ba9e457270b724001cf3393c5399c18b43b95d36d268c8d8d648a754d" => :high_sierra
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
