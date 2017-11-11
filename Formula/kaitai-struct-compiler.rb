class KaitaiStructCompiler < Formula
  desc "Compiler for generating binary data parsers"
  homepage "http://kaitai.io/"
  url "https://bintray.com/artifact/download/kaitai-io/universal/0.7/kaitai-struct-compiler-0.7.zip"
  sha256 "2fdd2646ea019bbf55be5bc27f24b037a7152514dbafbb7cfcdaf27a1d190045"

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
