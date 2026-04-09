class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "e60a89364f2b5d9c9b1f143175fc1a5018027a59bb31af56e5df88806b506e49"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1df6144f110d59a0a2702a819891b5d2431c1b2d5320c8a754c70c7afe121979"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d85a46d17cd0d8faa344925cc6e7a735c68efb81c30f9e7e366d160ef31c91f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33038f52f8f29283fa3a34105974fd9a816eb7afc123326c09b238f6ae51057b"
    sha256 cellar: :any_skip_relocation, sonoma:        "23633ba6707787461a94f4093040e6cf61a0d0e47e0bf4cc76122554952f5dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d26cd91d005741e2c3953bd72ec068bad724c4bfe83914ab96b18f988aeac93f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc0eb880e0fd2c7c033434e9433dd6ffc9af4b3ec6b61f81f705877f337f3bb6"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.14"

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  def install
    args = std_cmake_args
    args << "-DPARTIO_USE_GLVND=OFF" unless OS.mac?

    system "cmake", "-S", ".", "-B", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--build", ".", "--target", "doc"
    system "cmake", "--install", "."

    pkgshare.install "src/data"
  end

  test do
    assert_match "Number of particles:  25", shell_output("#{bin}/partinfo #{pkgshare}/data/scatter.bgeo")
  end
end
