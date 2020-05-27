class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.6.1.tar.gz"
  sha256 "c72249b52ddab30fe41bccad4cbba14baa84a51b4069f79450ea0fd6dea78130"
  version_scheme 1
  head "https://github.com/Ultimaker/CuraEngine.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d9822c078d322e27271b988695b8c62dcffb3c47a2d6cf3ba0924f8b7c2d718e" => :catalina
    sha256 "491aae5f2853ac119f560dc64fa8bc4afcc27bf1b218d6fd3cf8170e6b041858" => :mojave
    sha256 "7067dcf153826d767fc01831c4e535408ee1eca05b9bd7d858aca18964893ecb" => :high_sierra
  end

  depends_on "cmake" => :build

  # The version tag in these resources (e.g., `/1.2.3/`) should be changed as
  # part of updating this formula to a new version.
  resource "fdmextruder_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.6.1/resources/definitions/fdmextruder.def.json"
    sha256 "9f0b42c98e023b32784c340db2db91a25f78fc30ca770a4914ae9c48a24d3db3"
  end

  resource "fdmprinter_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.6.1/resources/definitions/fdmprinter.def.json"
    sha256 "142b4c17ed0270dfb76f23eb644a3a10c4e1c6be8ab35ff78ea2d3ea8a90f12d"
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
