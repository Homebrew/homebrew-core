class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.31.1",
      revision: "8229737a73fff12498828d90db099914adaa4a08"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4e1284325ad80b5d4c6e589e8adc23372a56cf3482e84da096d8c675d0183e78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b20580ad124635d2565de067f55fab0d6663e37115b06ff75ad2cdf0b61322d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2998b62f8be1dcf216104dbc1ed18156fb139811e37bf6bead68607f5cf74ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d118b214854355d4f480ccc5951afc51d4397b98fee0957d0f64b009e56f2d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "15fc89e21bf23719ba83534d1d84b9649f9421f20dad4039bd3b800c9e4e193e"
    sha256 cellar: :any_skip_relocation, ventura:        "4efba4aa60d5d2c8b256680a75fbd87ad1631b0d613cd5ecd6802d5d6f262f46"
    sha256 cellar: :any_skip_relocation, monterey:       "cf2605d4e7a521fa245742b315c57c0fb60050c976c1de7bc3c7b6ae81f271c9"
    sha256                               x86_64_linux:   "fe1dabe4d6b203d5f48510a08af48fe5b644fbead57a64c47c4a27d2652421de"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"

  uses_from_macos "python" => :build # required to compile .pb files
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
    assert_match "Creating backend [blas]",
      shell_output("#{bin}/lc0 benchmark --backend=blas --nodes=1 --num-positions=1 2>&1")
    assert_match "Creating backend [eigen]",
      shell_output("#{bin}/lc0 benchmark --backend=eigen --nodes=1 --num-positions=1 2>&1")
  end
end
