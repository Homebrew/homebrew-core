class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.6.1.tar.gz"
  sha256 "c72249b52ddab30fe41bccad4cbba14baa84a51b4069f79450ea0fd6dea78130"
  version_scheme 1
  head "https://github.com/Ultimaker/CuraEngine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8208f9fc4937de054b71fe33eabcaa9b8463453e09491c60473c390a18557cb" => :catalina
    sha256 "03459dc8fd06bc5522b8d0084ac2dd05f238316f009e8fa792f5e55218f5852e" => :mojave
    sha256 "b29d96d522832565490392c1945bec5be2fe5b48f2331fd121f706e06d7b6912" => :high_sierra
    sha256 "2f2c5d334057a9e99ef969f7f2cb66d357ab0c98e501a22103b4c53faa0ca8e8" => :sierra
  end

  depends_on "cmake" => :build

  resource "fdmextruder_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/master/resources/definitions/fdmextruder.def.json"
    sha256 "c56bdf9cc3e2edd85a158f14b891c8d719a1b6056c817145913495f7e907b1d2"
  end

  resource "fdmprinter_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/master/resources/definitions/fdmprinter.def.json"
    sha256 "e16ffd9f6412dc7160485f3452041ac1d56ba786d8cf65a009bdfc4be526d070"
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
