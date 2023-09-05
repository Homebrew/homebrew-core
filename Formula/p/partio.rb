class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/v1.17.1.tar.gz"
  sha256 "5d00fbfc55817acb310bcaf61212a78b2c602e08b839060dfee69570b4b82464"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "935ec96e13375384ce6b263dbf4acf0f918b2a24ce5144ebf87c668061ff95ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f98279b3c17a945d3028122d6664521f59b063a139ef6c1feb983b959abfc8f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a4e859dfd6003ac3a7394f58628d20313e359383b74f4ee19a6139edcfd743b"
    sha256 cellar: :any_skip_relocation, ventura:        "9f253e0b3b64df16adec10d8e8114043ed9beb885609f4cb012facfb7d12932d"
    sha256 cellar: :any_skip_relocation, monterey:       "d8dfa662b7ebcba6544e5f57cd660eaefd4b7c53c00ac51e673a32b76afcece8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e381afdcd2f65b39010690255b077479de6f43e3463eb139a2532c92d1b8440c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3578533db38009bf01e018fc2e691125d3396e0edcf142c4a4ea0cc311c2049f"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.11"

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = std_cmake_args
    args << "-DPARTIO_USE_GLVND=OFF" unless OS.mac?

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "doc"
      system "make", "install"
    end
    pkgshare.install "src/data"
  end

  test do
    assert_match "Number of particles:  25", shell_output("#{bin}/partinfo #{pkgshare}/data/scatter.bgeo")
  end
end
