class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "fab93a5d7cfbf7b069c2d082f68dfe968799f0612b28a22aada9eda50b87595e"
  license "BSD-3-Clause"
  head "https://github.com/dellytools/delly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6c02376e67ac46f63b6818772049ff523bbae5cf60e69b8c1ce746fe49b45dcc"
    sha256 cellar: :any, arm64_sequoia: "2a2812eacf50740f0b03fc9058d5e23aba3edea581ccc200a3a83646153b5546"
    sha256 cellar: :any, arm64_sonoma:  "4dc43e7e60de469381b722802da29cd216e0f5e556c3d00aa20c666850b29bb6"
    sha256 cellar: :any, sonoma:        "bdf7c33718038fc106b4d5fbf7cac37cfa618e11ca1ac784f8d35af60fcc3bf6"
    sha256 cellar: :any, arm64_linux:   "fe68cd948ac753d60b6ad0d22e02e07ac668c1d92add5d17f7f6c5fc7b88e966"
    sha256 cellar: :any, x86_64_linux:  "c192be9439c3b7fff3a7ac88b9ef5416ac711aad8ea43b4e250afdb2d728100b"
  end

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "make", "src/delly",
           "HTSLIBINCDIR=#{formula_opt_include("htslib")}",
           "HTSLIBLIBDIR=#{formula_opt_lib("htslib")}",
           "BOOSTINCDIR=#{formula_opt_include("boost")}",
           "BOOSTLIBDIR=#{formula_opt_lib("boost")}"
    bin.install "src/delly"
    pkgshare.install %w[example R scripts]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
    system bin/"delly", "lr", "-g", pkgshare/"example/ref.fa", "-o", testpath/"lr.bcf", pkgshare/"example/lr.bam"
    assert_path_exists testpath/"lr.bcf"
  end
end
