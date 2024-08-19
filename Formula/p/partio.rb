class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "08a571ca75cf133f373415dfd50b7d0e33a0dd1811dfb63409f0ae46652033c1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "797ccfe2fbd825a19397be286127b6324e0f667adbfe1cb7ed55e3dbebb0738d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f94e796a8de500173d1f38abb5dfd2df90efd79b53f3eb0c720a29a262178c68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a454868fbfb8cae81d7378f2cceb8a0a80090e68be97b951fcf8112e286416e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6471ee7399bb0a5716d8da41ebd57a67650f65829b56d36ad74732b29e489a2"
    sha256 cellar: :any_skip_relocation, ventura:        "a962b61c79ebbf651f653e5199a44ca809057dc3c771b511bd354babfe711880"
    sha256 cellar: :any_skip_relocation, monterey:       "673b079ad6d8a85208d26a41412e6d9f79182e200fa9e8f56ef74f099ce61b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "484bcec4c5896ca121126bf1a1ea79f82e4babfac09461e164a8aa77c8d9d752"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.12"

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
