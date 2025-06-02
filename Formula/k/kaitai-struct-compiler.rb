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
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7e88fea45af08e6beb052d86e17199f3a459673089185dbd25904024f430aa6b"
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
    assert_path_exists testpath/"Test.java"
  end
end
