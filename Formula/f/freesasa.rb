class Freesasa < Formula
  desc "Solvent Accessible Surface Area calculations"
  homepage "https://freesasa.github.io/"
  url "https://github.com/mittinatten/freesasa/archive/refs/tags/2.1.4.tar.gz"
  sha256 "1bc79b06985c868f76ccc5ff8fea6a1687c7d4d4b21e5c3636b52106b653807c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3ace0796c7285dbc23e161e13e5dbc95e2bb0ad141bd7941d4bb341a8d0755f7"
    sha256 cellar: :any, arm64_tahoe:       "a1625588f5e46a454620a3fa86c26afd07a1426a7b633fd3228ecb00cf201fb0"
    sha256 cellar: :any, arm64_sequoia:     "a12b834e8c80fafa40c8c8c59ef750250a237ceb24614cb18055277021806ac3"
    sha256 cellar: :any, arm64_linux:       "a65e7d352e1e3e903035b1a69c8b17bd96edc47bd20f66e6e43e69a1c897c57b"
    sha256 cellar: :any, x86_64_linux:      "310c887f6d500a1f26b40948520e5b142da67a09a93ee16128b85b5665894767"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "json-c"

  uses_from_macos "libxml2"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "tests/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freesasa --version")

    output = shell_output("#{bin}/freesasa #{pkgshare}/data/3bkr.pdb")
    assert_match "RESULTS", output
  end
end
