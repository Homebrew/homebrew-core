class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.7.0.tar.gz"
  sha256 "97edb730f7fc625bccca0ca460c751fb388135c83e0e31e86f0ba21be1b1a713"
  license "AGPL-3.0"
  version_scheme 1
  head "https://github.com/Ultimaker/CuraEngine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5da353ffcd1e618d614092acb41d96ca86d632ab4cb4ee0597fc54d52f1c70db" => :catalina
    sha256 "ebd004514df2d15c48ab82353f67d11291270ee9e720eb99c11cb7da8180ba81" => :mojave
    sha256 "51e2edf06313599f125cb2e45631dc61b2abb2dd3229d3130dd051a23b84d1d9" => :high_sierra
  end

  depends_on "cmake" => :build

  # The version tag in these resources (e.g., `/1.2.3/`) should be changed as
  # part of updating this formula to a new version.
  resource "fdmextruder_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.7.0/resources/definitions/fdmextruder.def.json"
    sha256 "c56bdf9cc3e2edd85a158f14b891c8d719a1b6056c817145913495f7e907b1d2"
  end

  resource "fdmprinter_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.7.0/resources/definitions/fdmprinter.def.json"
    sha256 "854ed5ca6adb423d4d5d7c564a9cbcd282c35c6aa2c5414785583fdd3a7c3923"
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
