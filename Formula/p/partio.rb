class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "b59fbc8e64561368f0e2f94ae2f3f2083babfc32ff7ae97e833ab15df4588ade"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "771ec48251036ec659478ba8b03a2de0b54ead6cff8d36a6920da1f43e8f4ff2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dcbd5bc580c7eb2e01783c5c1ea25133425064192e4769cd81708c4f34339f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70e9c354c6cc6a88cb4cdf27ba401ef8b462f93c22db7e62eb8791bad8532fa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb25df793e344f0df541ed08703703ceb5cdcc0c5a2052eba0689a842a088ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f776a69509e4f29643c21de169385952823e7edb84241b4e4d99bcb27d544604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58407db08bb0d50611a1621f82bf0a2dbde8f3415fe0e6f979f6eb492a72d205"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.14"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
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
