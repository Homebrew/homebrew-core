class Javacc < Formula
  desc "Parser generator for use with Java applications"
  homepage "https://javacc.org/"
  url "https://github.com/javacc/javacc/archive/7.0.5.tar.gz"
  sha256 "d1502f8a7ed607de17427a1f33e490a33b0c2d5612879e812126bf95e7ed11f4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9c275d1d13bdf1ca8a1055b7eebd36b965900df3e437212f088b81c1cbc1cd45" => :catalina
    sha256 "9ff7ba84bb480e5cd6e7e345a862c53388a3c6ae9ebd9a2fcdae39acb19522d4" => :mojave
    sha256 "d0f91587db34aeb3f695cc36ced30032515dc33e88fd41dc7623e4ad396c74d7" => :high_sierra
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
