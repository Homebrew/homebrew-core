class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.6.2.tar.gz"
  sha256 "17ad1dffbfa0526f2a255c1979d36dcc9b63166304be271556d9a2fd31a37e07"
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
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.6.2/resources/definitions/fdmextruder.def.json"
    sha256 "9f4f7d17dd4aa4dc0653193b990d0a79fe23d1d205ebe2ed0c2e6be10f56e03a"
  end

  resource "fdmprinter_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.6.2/resources/definitions/fdmprinter.def.json"
    sha256 "b3efe2ade1ccbdf3742068120fca0a5a3027933c0e58591ce32771ede6ac32de"
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
