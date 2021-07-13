class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.27.0",
      revision: "6bb93fbd1ac94b8e64943e520630c2f1db9d7813"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e9dc041c748fee70f187c04373ca80ba8c274d1b4b9a38ee135e6b4d6ce419fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "0966b60547f4f559ed7bd03cdd0bbe41abfed8e8a69b8553eb790e120aac0e24"
    sha256 cellar: :any_skip_relocation, catalina:      "ca05132c5b944255ce14f18960a59fa657d3dae1b9c088ff526b8763af793efc"
    sha256 cellar: :any_skip_relocation, mojave:        "7578de28c6a91e884166aa033e4682a3d4992390c85fd74c811acb584b1b3f45"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build # required to compile .pb files
  depends_on "eigen"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" # for C++17
    depends_on "openblas"
  end

  fails_with gcc: "5"

  resource "network" do
    url "https://training.lczero.org/get_network?sha=00af53b081e80147172e6f281c01daf5ca19ada173321438914c730370aa4267", using: :nounzip
    sha256 "12df03a12919e6392f3efbe6f461fc0ff5451b4105f755503da151adc7ab6d67"
  end

  # Fix compile error due to missing #include <condition_variable>
  # Remove in the next release
  patch do
    url "https://github.com/LeelaChessZero/lc0/commit/997257a16fc74c848ab55e475c4d233d78838506.patch?full_index=1"
    sha256 "5f4fb6b730a04bfd36567302bc4ad9d22f7f69c55c6fad35047a18d514210758"
  end

  def install
    args = ["-Dgtest=false"]
    on_linux do
      args << "-Dopenblas_include=#{Formula["openblas"].opt_include}"
      args << "-Dopenblas_libdirs=#{Formula["openblas"].opt_lib}"
    end
    system "meson", *std_meson_args, *args, "build/release"

    cd "build/release" do
      system "ninja", "-v"
      libexec.install "lc0"
    end

    bin.write_exec_script libexec/"lc0"
    resource("network").stage { libexec.install Dir["*"].first => "42850.pb.gz" }
  end

  test do
    assert_match "Creating backend [blas]",
      shell_output("lc0 benchmark --backend=blas --nodes=1 --num-positions=1 2>&1")
    assert_match "Creating backend [eigen]",
      shell_output("lc0 benchmark --backend=eigen --nodes=1 --num-positions=1 2>&1")
  end
end
