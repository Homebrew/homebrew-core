class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "80464cca840f7ecaeec63528cc5c4b138af83da909f91291115e1811e5f8cec6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38ca66556511219ef57e4ec8991140d72be49cc8ed7240b0004fb1345d4b1078"
    sha256 cellar: :any,                 arm64_sequoia: "94add6a086e5190bcf750c6d3df132f4aab9de601a0e281fca1287bd8c4da957"
    sha256 cellar: :any,                 arm64_sonoma:  "b478125d6abc5b0b1a3099cec1c1c3bef4e8ee77b3ff8023bb55561cd33d57f4"
    sha256 cellar: :any,                 arm64_ventura: "d93bcc0a58726987c2f85d0343d36522a3fbf527996200b3f32595186516df0c"
    sha256 cellar: :any,                 sonoma:        "aae3191433f4727df29a3d17e3f398feb0f98b27aa94adc865ae4dd2f5e8c7c7"
    sha256 cellar: :any,                 ventura:       "b0ac35b79913f6d2d87898190e664d2ff498f70dd88247ca209275c7df229f74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4eeec0d04b8f9a1bfd855dbfff1fcbb8368908e80b926b129a9a2885520b3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "355ac94844b557208ac0d9d15e6dab80b6c83c6185f1f4eb8231a13e0b5564ec"
  end

  depends_on "isa-l"
  depends_on "libdeflate"

  def install
    mkdir prefix/"bin"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "testdata"
  end

  test do
    system bin/"fastp", "-i", pkgshare/"testdata/R1.fq", "-o", "out.fq"
    assert_path_exists testpath/"out.fq"
  end
end
