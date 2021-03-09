class KaitaiStructCompiler < Formula
  desc "Compiler for generating binary data parsers"
  homepage "https://kaitai.io/"
  url "https://bintray.com/artifact/download/kaitai-io/universal/0.9/kaitai-struct-compiler-0.9.zip"
  sha256 "3038243334fb65bbb264f33b82986facfe1fbad2de1978766899855b40212215"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?kaitai-struct-compiler[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"kaitai-struct-compiler").write_env_script libexec/"bin/kaitai-struct-compiler",
                                                    JAVA_HOME: Formula["openjdk"].opt_prefix
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
    assert_predicate testpath/"Test.java", :exist?
  end
end
