class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.28.2",
      revision: "fa5864bb5838e131d832ad63300517f4684913e7"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d8bfca5ebff386f71840281f15ec3c04e2436f1fcb3529ce1eb5d10facbc9db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdc7f840a570db9c0f54a5055091fd16ab04399b68381d05e75071d5c61fd8e9"
    sha256 cellar: :any_skip_relocation, monterey:       "97af5c15368b7ccc506055dd37a7dabefb3fa437eafe3326b7c9a094ae6583f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "981faff9f38f2d4d40ea716e837f8ba45ea63dc627f80078af043110074204b0"
    sha256 cellar: :any_skip_relocation, catalina:       "bb01f65bcf9aa37e511b8235ffd2108dcc9176a4a6ab1c20eca909eb0f8146bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbe3c6e9c3e92df13902470ddae27d1cc2cebc26d395b5be01a82465ec940575"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build # required to compile .pb files
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

  def install
    args = ["-Dgtest=false"]
    if OS.linux?
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
