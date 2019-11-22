class Javacc < Formula
  desc "Java parser generator"
  homepage "https://javacc.org/"
  url "https://github.com/javacc/javacc/archive/7.0.4.tar.gz"
  sha256 "a6a2381dfae5fdfe7849b921c9950af594ff475b69fbc6e8568365c5734cf77c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b13e7c7f8c0761cdc61f143006fb632ee5fee4399b87f5f0230ade64792f5b0b" => :catalina
    sha256 "1929d7068a6b22f8b089d9805d755df470d5847761b7d610f38214b67b0b5270" => :mojave
    sha256 "d11bdf6d0d8d07db045ae2a99908f4746e50a95f0a4075bc41747e237b0b2370" => :high_sierra
  end

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
