class KaitaiStructCompiler < Formula
  desc "Compiler for generating binary data parsers"
  homepage "https://kaitai.io/"
  url "https://bintray.com/artifact/download/kaitai-io/universal/0.8/kaitai-struct-compiler-0.8.zip"
  sha256 "545fc10e134db2901cad8817be1b440fca6f2bad8b92b2948ebe0647f3ffa2c9"
  revision 2

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"kaitai-struct-compiler").write_env_script libexec/"bin/kaitai-struct-compiler",
                                                    :JAVA_HOME => Formula["openjdk"].opt_prefix
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
    system bin/"kaitai-struct-compiler", "Test.ksy", "-t", "java", "--outdir", testpath
    assert_predicate testpath/"src/Test.java", :exist?
  end
end
