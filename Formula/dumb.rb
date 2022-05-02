class Dumb < Formula
  desc "IT, XM, S3M and MOD player library"
  homepage "https://dumb.sourceforge.io"
  url "https://github.com/kode54/dumb/archive/refs/tags/2.0.3.tar.gz"
  sha256 "99bfac926aeb8d476562303312d9f47fd05b43803050cd889b44da34a9b2a4f9"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eafff4c73e4401c1d6cbb6a5ae9098dce369766057bf08516540f0ff24d48a92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d907efc07aefb58f43bca29a17b58957eb071c73e6aef3abd91e59687e5a78ed"
    sha256 cellar: :any_skip_relocation, monterey:       "bf474d0e438d7be3d3a7a432e4f0d4f8a27ae23165e37fe52f28c15118dec743"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ea105e8d30bae67ddb21a9e7eaba69cd2f372c41dd11d05f80756ec9d3fffee"
    sha256 cellar: :any_skip_relocation, catalina:       "dbb9dbb86ec1c5ff1bc9da976fe3ec481888b4c3cd5cd8b10b6c803b83d934f2"
    sha256 cellar: :any_skip_relocation, mojave:         "e2956b48f246b68f98a5b39e81e371bd544d78b7bb0e97f5282cfc27e9b307cd"
    sha256 cellar: :any_skip_relocation, high_sierra:    "674db2be479a742057619122759da52683c74b724b3e318f2fc71a4fa6bd7287"
    sha256 cellar: :any_skip_relocation, sierra:         "04219fcc6bf6cd174cb5c2ddde4bfdbff266ed665e543c9948911e731d682dc9"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d2352df11bee735e963b887609578ec1b3acf0e07748385f472a6add0e1cd2b6"
    sha256 cellar: :any_skip_relocation, yosemite:       "317ac8139d8efb03022bb4f9a76ad61f2358570680563924d13229c52b282dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b9703a5ec46976384a0fb16f851ef2ed5017eceba818383f0b7993b09a30542"
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "sdl2"

  def install
    args = std_cmake_args + %w[
      -DBUILD_ALLEGRO4=OFF
      -DBUILD_EXAMPLES=ON
    ]

    # Build shared library
    system "cmake", "-S", ".", "-B", "build", *args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Build static library
    system "cmake", "-S", ".", "-B", "build", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build"
    lib.install "build/libdumb.a"
  end

  test do
    assert_match "missing option <file>", shell_output("#{bin}/dumbplay 2>&1", 1)
  end
end
