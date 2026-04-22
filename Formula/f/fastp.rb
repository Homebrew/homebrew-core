class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "0c98acc55aa9771d854775db09cbf4c8fd1477d0b3dd3f3b08eebae0da0533db"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76816042b1596723b4aa00fe859a5b5780743a9cc0f774a17c6beb002baff445"
    sha256 cellar: :any,                 arm64_sequoia: "941fa77c39ea807b7c5803ac2c66c6a109d5ff8ad97a04d8156e99c22dc8b51a"
    sha256 cellar: :any,                 arm64_sonoma:  "e6dd7f854bab4313c472b9144ae82e1b73c7354d22b65ea37b96db8cf01c3563"
    sha256 cellar: :any,                 sonoma:        "5a167ba348fc68bd9f383bbd5efe12f86e29b41aabd27d89bf79478100296726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "133da372661ae8da9161f0010b0442cb7a3aa5a68f12d102c1f2c341fa465847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "309efe5258e1714f390988119d9da9a39d4848f4677748397f5e030ec8bf7546"
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
