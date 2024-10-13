class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "08a571ca75cf133f373415dfd50b7d0e33a0dd1811dfb63409f0ae46652033c1"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "156678f075f4be856918ad93364d8fabc320a1d21c3604091ae0a6ba80b13377"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac54c92b0170c31766af0d7bb486361b091bfba772fc410fb33132071f06652"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0da7b8ea9d0aed2ea12fbbb4e525d5a300552911bd1cf11f018f69cdd59c2e99"
    sha256 cellar: :any_skip_relocation, sonoma:        "ded84cbbbbafe20305db9f3bf9b64f5b041d2a6d76059a3235d442736d689a0e"
    sha256 cellar: :any_skip_relocation, ventura:       "8f6c84a190bd21fa1461172c3915aaf4b8e9f6912760a05854d7bd526e8f91ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15f6f86a2f0bcc8e1add259eaad579075a719f0c7bd53ed0301f54177ff72586"
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
