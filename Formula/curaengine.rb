class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.11.0.tar.gz"
  sha256 "d654c2e0397f87d75d4481591f9d7f5e252a4fb4bc61cf84a477223618674f80"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/Ultimaker/CuraEngine.git", branch: "master"

  # Releases like xx.xx or xx.xx.x are older than releases like x.x.x, so we
  # work around this less-than-ideal situation by restricting the major version
  # to one digit. This won't pick up versions where the major version is 10+
  # but thankfully that hasn't been true yet. This should be handled in a better
  # way in the future, to avoid the possibility of missing good versions.
  livecheck do
    url :stable
    regex(/^v?(\d(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bc036608a190ab251a7ea1cc6e8b581fc9b6af2f23680100a576c238c5d49df3"
    sha256 cellar: :any,                 arm64_big_sur:  "65db3e5bd79cd6d05b9f1b1977f4ac9cd4f5086bc2fb8805a2380cea66336823"
    sha256 cellar: :any,                 monterey:       "1efd9cfdf4422d0c4f2476c7365425bb4e7a1ea2d3e7fcf7df5a72961a7edd42"
    sha256 cellar: :any,                 big_sur:        "ecf3e469cedce0fc986b2648df563997806a9156c5cab3db8da2351fa0d0e07e"
    sha256 cellar: :any,                 catalina:       "ba5a690f2febe148e2fa836a840c996e6e41701379c152f8a32a2b5074e263fa"
    sha256 cellar: :any,                 mojave:         "bac60b2b7e9c50c1ea5dcb939d4dec14d7dedde5b0d972817a3fd17ba5a08ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d9f51fbe4721b8dc596e4d1b1ae2ac90f27a592f3422d177e538860b3034fc0"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # The version tag in these resources (e.g., `/1.2.3/`) should be changed as
  # part of updating this formula to a new version.
  resource "fdmextruder_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.11.0/resources/definitions/fdmextruder.def.json"
    sha256 "331c3e203eaf012b19b62795235becec9f1da8939e96fc6834213291269c769e"
  end

  resource "fdmprinter_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.11.0/resources/definitions/fdmprinter.def.json"
    sha256 "7e6d73c6165c6d50e09ed2b6cd417ebb82fe6832e99ebfec19f7584224ffd60c"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_INSTALL_PREFIX=#{libexec}",
                            "-DENABLE_ARCUS=OFF"
      system "make", "install"
    end
    bin.install "build/CuraEngine"
  end

  test do
    testpath.install resource("fdmextruder_defaults")
    testpath.install resource("fdmprinter_defaults")
    (testpath/"t.stl").write <<~EOS
      solid t
        facet normal 0 -1 0
         outer loop
          vertex 0.83404 0 0.694596
          vertex 0.36904 0 1.5
          vertex 1.78814e-006 0 0.75
         endloop
        endfacet
      endsolid Star
    EOS

    system "#{bin}/CuraEngine", "slice", "-j", "fdmprinter.def.json", "-l", "#{testpath}/t.stl"
  end
end
