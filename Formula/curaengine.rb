class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.5.0.tar.gz"
  sha256 "c6e63526f860ef42950236333c8a33db9f5beb9493ac5c8b69f5336501f1179e"
  # Looks like new version scheme was used for most recent releases since 15.04.6 in March 2016
  # https://github.com/Ultimaker/CuraEngine/releases?after=2.6.1
  version_scheme 1
  head "https://github.com/Ultimaker/CuraEngine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8208f9fc4937de054b71fe33eabcaa9b8463453e09491c60473c390a18557cb" => :catalina
    sha256 "03459dc8fd06bc5522b8d0084ac2dd05f238316f009e8fa792f5e55218f5852e" => :mojave
    sha256 "b29d96d522832565490392c1945bec5be2fe5b48f2331fd121f706e06d7b6912" => :high_sierra
    sha256 "2f2c5d334057a9e99ef969f7f2cb66d357ab0c98e501a22103b4c53faa0ca8e8" => :sierra
  end

  def install
    system "make", "VERSION=#{version}"
    bin.install "build/CuraEngine"
  end

  test do
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

    system "#{bin}/CuraEngine", "#{testpath}/t.stl"
  end
end
