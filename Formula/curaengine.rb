class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.13.1.tar.gz"
  sha256 "283f62326c6072cdcef9d9b84cb8141a6072747f08e1cae6534d08ad85b1c657"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70ae70cd08537fa72252acb5dff6adcf53590fd0f6b53d8a9086467268fa0a0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "785b4583e5c9dbbd9f96aaa4ffd9d1fd220ec0249ce7078258af6e24ba1f5c21"
    sha256 cellar: :any_skip_relocation, monterey:       "f1ff180d451a0920cc216c27f0925224b335539dea2661f19c868e5ef555bdce"
    sha256 cellar: :any_skip_relocation, big_sur:        "daec837ab750b488dda7f16682577d599afddc946c8f4bddadf416166b71c9f9"
    sha256 cellar: :any_skip_relocation, catalina:       "4520ab1977dc1de4c1881b3ffa5d432502d8d4c290df9a51efe4eea6bc24a0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd5b8cda799f82c437e9828ee4065b25b9050c7fece76d2c2bcaaa923e6b9956"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # The version tag in these resources (e.g., `/1.2.3/`) should be changed as
  # part of updating this formula to a new version.
  resource "fdmextruder_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.13.1/resources/definitions/fdmextruder.def.json"
    sha256 "c03847252f9dea37277a3151c0eaeec32ded5e4cd91eed62b58e420ad8cb7fef"
  end

  resource "fdmprinter_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.13.1/resources/definitions/fdmprinter.def.json"
    sha256 "6634679e3a9571f877e52e57a688d883dc4dc9fe6855a04c3b7be19b60f3a0b7"
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
