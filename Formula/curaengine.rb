class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/15.04.tar.gz"
  sha256 "d577e409b3e9554e7d2b886227dbbac6c9525efe34df4fc7d62e9474a2d7f965"
  head "https://github.com/Ultimaker/CuraEngine.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f3e4523d845e891ef23e56d95ab48454d22bebcc0f179a0806096009833e6acb" => :mojave
    sha256 "750b6ca6224c47f14cafa72bdca8f204348fdffda46289234b6f1e3c7f8b53ce" => :high_sierra
    sha256 "6319dc4f7e2648f801728e4aaf0aff747ae305ca9f6130181d164f222f40d160" => :sierra
    sha256 "73def7a0bbe0e297fd6490c0b0fd481265814918ffa42bf83febd5f1e68d7149" => :el_capitan
    sha256 "4252263a845ca5fc5631c4211eac9a95ad53e20cc07dfa0ea6422ea83ca178e7" => :yosemite
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
