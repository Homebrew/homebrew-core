class KaitaiStructCompiler < Formula
  desc "Compiler for generating binary data parsers"
  homepage "https://kaitai.io/"
  # Move to packages.kaitai.io when available.
  url "https://github.com/kaitai-io/kaitai_struct_compiler/releases/download/0.10/kaitai-struct-compiler-0.10.zip"
  sha256 "3d11d6cc46d058afb4680fda2e7195f645ca03b2843501d652a529646e55d16b"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?kaitai-struct-compiler[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18b4819a150e1f029f8716fcc304b18f59363dcf975d4271ff9b9b0129ebec72"
  end

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
