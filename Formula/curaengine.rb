class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.9.1.tar.gz"
  sha256 "eb422ef388bee09d26bbf3bade489359bf1fd59fd04d8452ac5d6ab3ba5e3894"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/Ultimaker/CuraEngine.git"

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
    sha256 cellar: :any, arm64_big_sur: "7551b87adf579e74e8469e37e4af3e5e57e5d132b02828a4b8331e3b93bdb0ab"
    sha256 cellar: :any, big_sur:       "fd8acf73caf3d14af5fe1d4cbcbb486a315f352139a6dbc4b836ea4568955d55"
    sha256 cellar: :any, catalina:      "0087d26cdeaa2a02e0d3ef8e4e5eb577c18e0d74f90047e5dd509c4eea903c31"
    sha256 cellar: :any, mojave:        "aa47077792c283be3ecda128bbad0f9686db11dce5dcf08ac3dbb34e1bfd2ea5"
  end

  depends_on "cmake" => :build

  # The version tag in these resources (e.g., `/1.2.3/`) should be changed as
  # part of updating this formula to a new version.
  resource "fdmextruder_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.9.1/resources/definitions/fdmextruder.def.json"
    sha256 "d9b38fdf02d1dcdc6ee7401118ca9468236adb860786361e453f1eeb54c95b1f"
  end

  resource "fdmprinter_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.9.1/resources/definitions/fdmprinter.def.json"
    sha256 "bc4ed29f1c4191ccf6fa76b0a2857aca7ab6ed2a5f526364f52910f330dfa6a6"
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
