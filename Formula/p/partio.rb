class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "128913266a88a0939aaa4bc951ae4d4da1c380408bcc0ea9e7f526556afeaad0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d590d5b336289ccc4cd9f862c647d95bbd69f338667fe20b7919b85aaa0be0cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "915f63605c761393c849667661d157e7dea78ad590877de5b5bac17e94c746a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b11218fc52dd89ebea09525a28d6c545598962faf5b9faf63607c357944fcc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "95b4c5061132adf97267f3a52c0a35476124df0f40ad54c93d7e0c141605277f"
    sha256 cellar: :any_skip_relocation, ventura:       "7300f161aaa679f5798b6a8bab305da1a22777b5a17e6a07ee7e4d2b750ba93e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5866cdd8c7d761d3cacdea80dc76cf177dc986e9b0b2e2518b2d325b2b556a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5376a76f425c703390142d15aec36b56a8b14cd9ef133abca229838a377c238c"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.13"

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
