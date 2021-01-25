class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.8.0.tar.gz"
  sha256 "752977fbe48653743b9f1a6e25e6d1f061513b7cf1cd4f0105b233595e8a15ff"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/Ultimaker/CuraEngine.git"

  # Releases like xx.xx or xx.xx.x are older than releases like x.x.x, so we
  # work around this less-than-ideal situation by restricting the minor version
  # to one digit. This won't pick up versions where the minor version is 10+
  # but thankfully that hasn't been true yet. This should be handled in a better
  # way in the future, to avoid the possibility of missing good versions.
  livecheck do
    url :head
    regex(/^v?(\d+\.\d(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ea4ddbed801958a3b9298b30a27fe638906bb7c04e78d5e0d7035872c0d1c680" => :big_sur
    sha256 "b15d57215d219b206a17d7f381ca367df0653758f7c1cba901b09612265971bc" => :arm64_big_sur
    sha256 "6d732ea2dfbe75f23ada46f804a627b425bb5b091aca784f5139f63746a7ba56" => :catalina
    sha256 "7c98a1ae8a3d08afe1fdf6eb7baa1ed273dc7b04edc8c01bb4a91d1147ac6810" => :mojave
  end

  depends_on "cmake" => :build

  # The version tag in these resources (e.g., `/1.2.3/`) should be changed as
  # part of updating this formula to a new version.
  resource "fdmextruder_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.8.0/resources/definitions/fdmextruder.def.json"
    sha256 "d9b38fdf02d1dcdc6ee7401118ca9468236adb860786361e453f1eeb54c95b1f"
  end

  resource "fdmprinter_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.8.0/resources/definitions/fdmprinter.def.json"
    sha256 "16381c4b888fcc787c77c95945635b0837f6b40761f7c0c442a1716e30d932f7"
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
