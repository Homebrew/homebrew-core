class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.29.0",
      revision: "afdd67c2186f1f29893d495750661a871f7aa9ac"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89b183e7deea7ff39d8463e70fc1b5da7e3fc547f90e91bf43baf1c8a3d49f99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdd6bfd76c58c7213d23bf1946340030701c6a57dbb171026c9213be6cd6be8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d8bd4640d5eeca48ddf2c88cc5f606504f59d66d17aec6dabcb7333863ed07d"
    sha256 cellar: :any_skip_relocation, ventura:        "576652ad17704ee01de8a1637d56e58fa0d0a52ae00fbe512bb10a90d3386e0d"
    sha256 cellar: :any_skip_relocation, monterey:       "87f1af61af279b1e06d96659d6b28f6eb6ef1accea4875e5fdb066ce2383219f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d353339a78402996038ae6938477da3f0f4e29c1edcd74bbe9617374d90ff062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aae4b4e1fd9587f3dc01724c83c364af205428342507617e20f3f7a6de7f774"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build # required to compile .pb files
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
