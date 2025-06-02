class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "55fa7d9b8166200e901ff59a1825ba6455ec1a322d9465ce40aae6d145c3146f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af02e4c10512d505e6d7b0aa8518369a769843ae6b1effe99873a436e585d6df"
    sha256 cellar: :any,                 arm64_sonoma:  "827b8becefcd46525899f074e7ac0d7adc9be63e4b13318f93fea483bc246332"
    sha256 cellar: :any,                 arm64_ventura: "514ede48a29fa497975e4d25b7426a26b19cb7d1a3c3130a3e50b8003a3c637f"
    sha256 cellar: :any,                 sonoma:        "79904c37db018628e8ea1ec5bd0dbc698daf0127f7a6b8ebbf6ae8c39a894794"
    sha256 cellar: :any,                 ventura:       "18c98cb5ab6524378509b2a858ef455be406c536777f15b6727bb67b3dae24bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6cb836857e8ad1ebb9fe04bd8ade14e5627625081a2b582dd96f80aa9994a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "924c9db74a7c3048521f3b5da0f2c932a571acfed049d1530b110e70672ea5c5"
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
