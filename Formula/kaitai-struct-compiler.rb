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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72c9d12038d82a2357191e78f55f840b4016afb055725244c9b26c770dc112e5"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b0f1975d18c49cb063c56d10d4788d355ca31936046d430609314740cba4058"
    sha256 cellar: :any_skip_relocation, catalina:      "5b0f1975d18c49cb063c56d10d4788d355ca31936046d430609314740cba4058"
    sha256 cellar: :any_skip_relocation, mojave:        "5b0f1975d18c49cb063c56d10d4788d355ca31936046d430609314740cba4058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "546340d4c6241a006245544f6759c6cd7051a9136021ce28b9533acf1da98f85"
    sha256 cellar: :any_skip_relocation, all:           "546340d4c6241a006245544f6759c6cd7051a9136021ce28b9533acf1da98f85"
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
