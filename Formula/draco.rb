class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.5.5.tar.gz"
  sha256 "6b7994150bbc513abcdbe22ad778d6b2df10fc8cdc7035e916985b2a209ab826"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d125b70e3112dfe4fa9c0c64a777ae0782754706d6f48bfa220bc1d048620fc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e03c02dc079701bd18c42c8f949888450af209d5761aa9436d67bb09e5eb8404"
    sha256 cellar: :any_skip_relocation, monterey:       "6f7d00987281befc76e0dabe0cd6718c3d89167c3c36fa5f0758c7ec34fa85dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ca0d289d21767b986b0b8d62bc8063f5956c623ed8177c2f73130188ef6450d"
    sha256 cellar: :any_skip_relocation, catalina:       "dfc253ee525ef179fe2697b818fbf62da54857ed4edb771623f023da4a1d3bb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf1490eb44edc697db2afff03ccc69905df3c07411d5b9fef1d55041520bd058"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", * std_cmake_args
      system "make", "install"
    end
    pkgshare.install "testdata/cube_att.ply"
  end

  test do
    system "#{bin}/draco_encoder", "-i", "#{pkgshare}/cube_att.ply",
           "-o", "cube_att.drc"
    assert_predicate testpath/"cube_att.drc", :exist?
  end
end
