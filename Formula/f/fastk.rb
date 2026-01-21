class Fastk < Formula
  desc "K-mer counter for high-fidelity shotgun datasets"
  homepage "https://github.com/thegenemyers/FASTK"
  url "https://github.com/thegenemyers/FASTK/archive/refs/tags/v1.2.tar.gz"
  sha256 "2e347fd698ea109685868149dd2d9c43aefc373f70ad7df8e303e0724f75c850"
  license all_of: [
    "BSD-3-Clause",
    { all_of: ["MIT", "BSD-3-Clause"] }, # HTSLIB
    "MIT", # LIBDEFLATE
  ]
  head "https://github.com/thegenemyers/FASTK.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dbf94aee71c34e3a2644f68cfb723ac923cfa0c2630a73ad0ee3e80a8e13bb6d"
    sha256 cellar: :any,                 arm64_sequoia: "841a82ecf23c7ba9cccd20349996d572d27324da65d3f5982fef0c25aa4553c9"
    sha256 cellar: :any,                 arm64_sonoma:  "ff2f90f2f2054f7265e25e790b912f74e37df46029785bdd210baf7322bd02b1"
    sha256 cellar: :any,                 sonoma:        "22bd3e62a70da1bac99c54b1b004ced04f5ef4263e32a0082f0dff7cc730bcae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b6eeb3bac5b53c4228b7fd8de9521bf50edaead7c72e0668135dcdde1133e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ecba9c2b7c4ff74bc2e0d288c109a6e729908ed4dd93b143a4c66968ec466aa"
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize

    bin.mkpath
    system "make"
    system "make", "install", "DEST_DIR=#{bin}"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"FastK", "test.fasta"
    assert_path_exists "test.hist"
  end
end
