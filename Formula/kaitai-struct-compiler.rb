class KaitaiStructCompiler < Formula
  desc "Compiler for generating binary data parsers"
  homepage "http://kaitai.io/"
  url "https://bintray.com/artifact/download/kaitai-io/universal/0.8/kaitai-struct-compiler-0.8.zip"
  sha256 "545fc10e134db2901cad8817be1b440fca6f2bad8b92b2948ebe0647f3ffa2c9"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["lib/*"]

    (bin/"kaitai-struct-compiler").write <<~EOS
      #!/bin/bash
      java -cp "#{libexec}/*" io.kaitai.struct.JavaMain "$@"
    EOS
  end

  test do
    (testpath/"Test.ksy").write <<~EOS
      meta:
        id: test
        endian: le
        file-extension: test
      seq:
        - id: header
          type: u4
    EOS
    system bin/"kaitai-struct-compiler", "Test.ksy", "-t", "java", "-d", testpath
    assert_predicate testpath/"src/Test.java", :exist?
  end
end
