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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3c5879f5bfe08955fd1efa5c04ce712c5fa2d3c614f987b840c936c78fcc56ac"
    sha256 cellar: :any,                 arm64_sequoia: "7948d902262e70e4fa643fb0d53edd9a528e60aaea4e4c3b856169dfb8f53162"
    sha256 cellar: :any,                 arm64_sonoma:  "4ba4799f17bdf58d708377941c8eaa4774efd90fe33c8fefe3409c4b76148c9b"
    sha256 cellar: :any,                 sonoma:        "2a83f988b220e7f71054b4f0e97c20d6378ffdeb5fb9317969f2b244b0b399e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5d202af3430f6567bd429b27996dbe06a70270c5762c80dfc770e043e4615dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ef7d92d57021d41d511f385ca9e66110625cb091d7f882ab3dd367762c285ee"
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
