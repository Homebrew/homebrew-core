class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c55656dfe9c3a40d3da59d680aa4ff4a2a4861bbc3993cb3659cdeb5e23fd858"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b3cd27137c016fb30ab7133d42eba0d526a4c8174cb994432a95a2339596393"
    sha256 cellar: :any,                 arm64_sequoia: "04de2eb48361d2a6ab031fe66587ac5ad3cf8302b038d457970a7baf82a9a2c9"
    sha256 cellar: :any,                 arm64_sonoma:  "20f35cc1600e805a27251b15ddadd0a82ed873e424bc561b69deb5516f5f8a1c"
    sha256 cellar: :any,                 sonoma:        "8be6ff536586710382c0f15a05f989464b0039cd3272f2fcd45125ac2a9c5990"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea2cc9354495f7f1348ce86b73d3bd6e1f8d2edad4b67860a1c99dc72c74208b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b89099cd70d5c4504b6a2ac388b9a43c9316d3fc0c61476b1844127c4040967"
  end

  depends_on "highway"
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
