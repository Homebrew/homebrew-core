class Javacc < Formula
  desc "Java parser generator"
  homepage "https://javacc.org/"
  url "https://github.com/javacc/javacc/archive/7.0.4.tar.gz"
  sha256 "a6a2381dfae5fdfe7849b921c9950af594ff475b69fbc6e8568365c5734cf77c"

  depends_on "ant" => :build
  depends_on :java

  def install
    system "ant"
    libexec.install "target/javacc.jar"
    doc.install Dir["www/doc/*"]
    (share/"examples").install Dir["examples/*"]
    %w[javacc jjdoc jjtree].each do |script|
      (bin/script).write <<~SH
        #!/bin/bash
        exec java -classpath #{libexec/"javacc.jar"} #{script} "$@"
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
