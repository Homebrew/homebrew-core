class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.29.0",
      revision: "afdd67c2186f1f29893d495750661a871f7aa9ac"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4207b3c56b8f65325b3c9782709acbbf7e8f4d93506b8496915f698d47146236"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bae2d59b3ac882fececa7710510016b12dd6b57d2d580874efe396ddb799a17a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "529596b859865c633ea43260221fa74fbd1b8ddbd3d2b060ed10bca556d87d00"
    sha256 cellar: :any_skip_relocation, ventura:        "99df228e19fd20db746645acb4cd25f4bdd5a6d26fcac45006fd2e7fb1914333"
    sha256 cellar: :any_skip_relocation, monterey:       "55df9f9ee77017ddf717361595fcd0267ab1df6f06e515ba3ea19eccd7c35fde"
    sha256 cellar: :any_skip_relocation, big_sur:        "4decdac18080cd1a01fad5d8b2e263847d6e51feceb3ec7d4ec010e6c8eae887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c788dcf4a6b1acfa7d96d1cc80fb0dd4c20b049b840a6068c19e52c729cdf7b"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build # required to compile .pb files
  depends_on "eigen"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openblas"
  end

  fails_with gcc: "5" # for C++17

  # We use "753723" network with 15 blocks x 192 filters (from release notes)
  # Downloaded from https://training.lczero.org/networks/?show_all=0
  resource "network" do
    url "https://training.lczero.org/get_network?sha=3e3444370b9fe413244fdc79671a490e19b93d3cca1669710ffeac890493d198", using: :nounzip
    sha256 "ca9a751e614cc753cb38aee247972558cf4dc9d82c5d9e13f2f1f464e350ec23"
  end

  def install
    args = ["-Dgtest=false"]

    # Disable metal backend for older macOS
    # Ref https://github.com/LeelaChessZero/lc0/issues/1814
    args << "-Dmetal=disabled" if MacOS.version <= :big_sur

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
