class Javacc < Formula
  desc "Parser generator for use with Java applications"
  homepage "https://javacc.org/"
  url "https://github.com/javacc/javacc/archive/javacc-7.0.9.tar.gz"
  sha256 "8f16103c741761f8fb6b9caef1c941ba9dd2d0cca01fd0bee26cdadf19a5af14"
  license "BSD-3-Clause"

  livecheck do
    url "https://github.com/javacc/javacc/releases/latest"
    regex(%r{href=.*?/tag/javacc[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6eebc2e971b6ec0bd1fd0010541833623c24b4d6f2fb6f83026b927a209f0bc1" => :catalina
    sha256 "73510c8870303d486394d2ec540a2f1c48432da6ed795de25b13f2d4f079c16e" => :mojave
    sha256 "e1bd0b87cb040d9d7d07be29fc66b4c0b82a530cff669a620009d4bc739281d3" => :high_sierra
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
