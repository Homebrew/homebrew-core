class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.28.1",
      revision: "d2e372e59cd9188315d5c02a20e0bdce88033bc5"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3f06ad878fb931803ee05e95c4fa0ab226ae6c9d27aeb7d7031d9f255704bb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a8a8a17f78fc04420a88a0b334cc18b4685f902c434c37a381c39746282e713"
    sha256 cellar: :any_skip_relocation, monterey:       "cc793affcd08b9b407656000cd0878ef0357d7e215454d1ce144df038ae766e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "86c82b9188b616a92ac8a8883fc6898b103a811c830db4d92cf30f7fe4449042"
    sha256 cellar: :any_skip_relocation, catalina:       "dc0ceda99050965775c86847e82f726fa4d7ee8eef2113e02cbaba1ea88bf148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "289dace72bea35c8064c1b29b504164008f674b6cca1d276370138c535aaae0c"
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
