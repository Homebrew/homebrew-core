class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.32.0",
      revision: "b38ed00a25baed9554d2675ec376bd50dad18195"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfa2e003712c83cf24db14df3fb5ae45758e25d7307506679bd9c6003cb72c4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08df3d2c0eb7d4571bf5bacaa436ac6e23b24979b9ff7349d72e352820f91b44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f67750b0910b02325d26e853b86a254e83730bfb2e60bd703575b9e0a6f97c4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79d4a818b6d4a1a054d5892dc229458f0cae2b62b118e424e4558c29d7ae7d02"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ea09794d327def86a09029fd374f12cd3b93cd90b0084a11ff06e8a3d9a8eb6"
    sha256 cellar: :any_skip_relocation, ventura:       "97cb78d9acb0574558469120aaa61f7f5a073653e2c186c6aa281a5f3b56c505"
    sha256                               arm64_linux:   "597af4ff6ee3a386b77f1384aa022219636d9108d8c27ff129d68ae3fda1d32a"
    sha256                               x86_64_linux:  "48cd3dba808ce82f2eb76319df3f745c0543f30700dcdfc1fa0ee26225feee0c"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"

  uses_from_macos "python" => :build # required to compile .pb files
  uses_from_macos "zlib"

  on_linux do
    depends_on "openblas"
  end

  # We use "753723" network with 15 blocks x 192 filters (from release notes)
  # Downloaded from https://training.lczero.org/networks/?show_all=0
  resource "network" do
    url "https://training.lczero.org/get_network?sha=3e3444370b9fe413244fdc79671a490e19b93d3cca1669710ffeac890493d198", using: :nounzip
    sha256 "ca9a751e614cc753cb38aee247972558cf4dc9d82c5d9e13f2f1f464e350ec23"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["eigen"].opt_include}/eigen3"

    args = ["-Dgtest=false", "-Dbindir=libexec"]

    if OS.mac?
      # Disable metal backend for older macOS
      # Ref https://github.com/LeelaChessZero/lc0/issues/1814
      args << "-Dmetal=disabled" if MacOS.version <= :big_sur
    else
      args << "-Dopenblas_include=#{Formula["openblas"].opt_include}"
      args << "-Dopenblas_libdirs=#{Formula["openblas"].opt_lib}"
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    bin.write_exec_script libexec/"lc0"
    resource("network").stage { libexec.install Dir["*"].first => "42850.pb.gz" }
  end

  test do
    assert_match "BLAS vendor:",
      shell_output("#{bin}/lc0 benchmark --backend=blas --nodes=1 --num-positions=1 2>&1")
    assert_match "Using Eigen",
      shell_output("#{bin}/lc0 benchmark --backend=eigen --nodes=1 --num-positions=1 2>&1")
  end
end
