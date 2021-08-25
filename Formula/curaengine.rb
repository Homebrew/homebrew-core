class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.10.0.tar.gz"
  sha256 "bbc931251c89f68b8670cd0e5a06b81fde99a5e440bdbfe0e7efc3a749642157"
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
    sha256 cellar: :any,                 arm64_big_sur: "0c8821b798cd37fe3199ddfa21288bb3049f4bcd4350b2e14d8b1fedf6a754f3"
    sha256 cellar: :any,                 big_sur:       "6bdc9ca0cf42b3f82d039e73677951aad14b52fbdfa1541df33f87a081f5961a"
    sha256 cellar: :any,                 catalina:      "39de4cd10de8d37adbdbf7f619c0608c545d2b14583bbd33a1651251806af015"
    sha256 cellar: :any,                 mojave:        "c6359e44f4649d07bc9259ae2d4918a036f99502aef4599d9515fa6c2ad6a5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c0cd72ecdcb5fd46db6dfa701b7570f65ec64f382aa069c64502df2a33826b3"
  end

  depends_on "cmake" => :build

  # The version tag in these resources (e.g., `/1.2.3/`) should be changed as
  # part of updating this formula to a new version.
  resource "fdmextruder_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.10.0/resources/definitions/fdmextruder.def.json"
    sha256 "dee47d679c5adcccf9f3302726af533eb03e5250d75355a3334ffcdbb85f8445"
  end

  resource "fdmprinter_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.10.0/resources/definitions/fdmprinter.def.json"
    sha256 "353248f099f0b58e29d0cc19b1dbe75c5b94c977e1e77ecdae6028a457dcb235"
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
