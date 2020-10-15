class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.7.1.tar.gz"
  sha256 "7e1e408f269a604418f37575ba8ef5f69323bebc4dd7f3091c1c2e9b000ffcbf"
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
    sha256 "b1b33c714035d7400481caec6af52fe0cd9cceb2ca9f6d528bfd12393e16ff73" => :catalina
    sha256 "7463c7161e156ae11f125994dc7eae5b95e2b6a2a7df3f3582e835cc2eddfaa2" => :mojave
    sha256 "da76f6f441244dfd0543b07a07fa02a84f04a494a189148d3e3784789136f861" => :high_sierra
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
