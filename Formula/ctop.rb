class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
    tag:      "v0.7.5",
    revision: "c971d26d42a7998b8883fee32d4b29d424992dec"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b84f39cf98350fdf2da48be62726e88c1b2d2aa9e5723793eac9c933390a3f14" => :catalina
    sha256 "8daf376c6606f7c5ed72c12a5f9693f2783300b4357e83e340ea66dc49337e83" => :mojave
    sha256 "624485ec30dde2d321702f37ca0506f91c4480ed1fe3d89e23c69c8996e26149" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ctop"
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
