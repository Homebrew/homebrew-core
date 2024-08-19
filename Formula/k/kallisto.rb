class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/refs/tags/V0.51.0.tar.gz"
  sha256 "efeb0191c1a6a0d6de69111fb66f4bda51ff31fb40c513280f072bd44556f80d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd8d0834c5c6426824aa215d5c2f1a89d42a0adb5e8ff48b1ef4398fd432cfb9"
    sha256 cellar: :any,                 arm64_ventura:  "f823ddc6d52f2ad690007bf638560086d09b781d3b67cf934dca4dc83e189027"
    sha256 cellar: :any,                 arm64_monterey: "0680066baf90e1e27b093dc12b453ee71902d498e77b01836950f31e4ea57999"
    sha256 cellar: :any,                 sonoma:         "d2a8d404b8fd448dd4c221ee52f3af4d0dcb73e7a09e8e9754dbae4cf1c85dc1"
    sha256 cellar: :any,                 ventura:        "2ff18ec926f91197f615780bb905763b53a177fa4f62fd6d1e66e33b09812b72"
    sha256 cellar: :any,                 monterey:       "501c9dedb5a462f429784266916d7fa8bbb4b7f603a8780120d0ff8691dc04b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7a815fb9879dd352e5f446e53bb670c2c6ddde8cb2324f7e9f6876b4bd2db47"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    ENV.deparallelize

    system "cmake", ".", "-DUSE_HDF5=ON", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >seq0
      FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVCLVYRTDQAQDVKKIEKF
    EOS
    output = shell_output("#{bin}/kallisto index -i test.index test.fasta 2>&1")
    assert_match "has 1 contigs and contains 32 k-mers", output
  end
end
