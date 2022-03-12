class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.28.2",
      revision: "fa5864bb5838e131d832ad63300517f4684913e7"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0149c068236cfe521a6aafe5083ec174b066752d54f73cbc6c992e05695c5096"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6a3bbc090e373bb6e853c2293bee476bd8f1d742bc680c68ab58dc024bbf02c"
    sha256 cellar: :any_skip_relocation, monterey:       "500a846f8a6c009a3627a7df6f2c3b7f4448098613bafe7306dee966be608c0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "09cf90ef36704a2eda92d9aac9c1a1f373419d5dc35bd8e9db5a61f2aa0c65c8"
    sha256 cellar: :any_skip_relocation, catalina:       "9d90fc5fbd36c50d08b65cae6a062571792d2b6d6b0873ddc088a6d5d675822b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "831694a2beb800b461acbdc7ccf5fc2effc0443e27eae49e2237c2e4c16986ca"
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
