class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "84df6f0cc6380e264130aef84f3beff5dac46ce15a0646270bf8aa2042563ed2"
    sha256 cellar: :any,                 arm64_ventura:  "eed79946a708962c5ad04765d72fa6dded46941cd159ad1676e8cd0ee3357788"
    sha256 cellar: :any,                 arm64_monterey: "8dfa9c9241af62469bb2f11db2b30391b235876be074e1b1a4d2be4722012c83"
    sha256 cellar: :any,                 sonoma:         "6268850a0f79868a34d346050671746c6e1281594f25f4bb53a6de0a91948a8a"
    sha256 cellar: :any,                 ventura:        "f42f01b241ac2b5874857bc2f1bc1ead8f64fc6a2f6465e6008e6088a8abf651"
    sha256 cellar: :any,                 monterey:       "b2ba1c3bdf4e8be5af1e806ff330f8f75999e7908be12c86c5986d317bd81257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1dc5bb8c660095d53bcb341733c6fc86700289ce8e7f2a46dfeada6e70b141"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  conflicts_with "dynet", because: "freeling ships its own copy of dynet"
  conflicts_with "eigen", because: "freeling ships its own copy of eigen"
  conflicts_with "foma", because: "freeling ships its own copy of foma"
  conflicts_with "hunspell", because: "both install 'analyze' binary"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install "#{bin}/fl_initialize"
    inreplace "#{bin}/analyze",
      ". $(cd $(dirname $0) && echo $PWD)/fl_initialize",
      ". #{libexec}/fl_initialize"
  end

  test do
    expected = <<~EOS
      Hello hello NN 1
      world world NN 1
    EOS
    assert_equal expected, pipe_output("#{bin}/analyze -f #{pkgshare}/config/en.cfg", "Hello world").chomp
  end
end
