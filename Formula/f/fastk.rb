class Fastk < Formula
  desc "K-mer counter for high-fidelity shotgun datasets"
  homepage "https://github.com/thegenemyers/FASTK"
  url "https://github.com/thegenemyers/FASTK/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "28a2de98ede77d4b4476596851f92413a9d99a1d3341afc6682d5333ac797f07"
  license all_of: [
    "BSD-3-Clause",
    { all_of: ["MIT", "BSD-3-Clause"] }, # HTSLIB
    "MIT", # LIBDEFLATE
  ]
  head "https://github.com/thegenemyers/FASTK.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc231c5bdda83a2f6d4b0b055dbb01b0c04538ac8d7cc205c71c28d40cba6215"
    sha256 cellar: :any,                 arm64_sequoia: "3353729044c15f3346d333ce0193e5b44a1acb6930dd366dcfc6866ded0799eb"
    sha256 cellar: :any,                 arm64_sonoma:  "9c4a36e6d522b8f31f730f540d0b1e6965670f3ff255614b775f846a4da52f9a"
    sha256 cellar: :any,                 arm64_ventura: "abfc4aa55dbb53cd4535be291b4f7e80ce1c4d8800c920d76a3841519de2106a"
    sha256 cellar: :any,                 sonoma:        "8c10092d5785b5c01b59e1056cc325262c1c2ada41fa15e7461b5cb42047044a"
    sha256 cellar: :any,                 ventura:       "111de43badf1291cbe29c4da58b3a84b8e939a2112501a7d31a3fa8c819520ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62800b4a4af5fae6b2f7218d1c414c21149472aedc6bda51b5699b9bdee9fe09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ab8e41e3503fc53dc426cd009b1414ed9e7f79e0666543180f7e7a50c857077"
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize

    mkdir bin
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
