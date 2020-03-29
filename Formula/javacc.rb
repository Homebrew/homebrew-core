class Javacc < Formula
  desc "Parser generator for use with Java applications"
  homepage "https://javacc.org/"
  url "https://github.com/javacc/javacc/archive/7.0.5.tar.gz"
  sha256 "d1502f8a7ed607de17427a1f33e490a33b0c2d5612879e812126bf95e7ed11f4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9761db5815a3cad526876b7385e61c353a287620dbd160a4f8d880dea4ccc573" => :catalina
    sha256 "7cdce912a379ca72671e0c8590adf35d97931943a7e75d7f15c08a3f2994d832" => :mojave
    sha256 "f08bee3c211b72483fdb6666a71eff1f0c98f645e21f83c97a1cda78ad99fd9d" => :high_sierra
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
