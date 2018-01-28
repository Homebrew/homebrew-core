class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.3.tar.gz"
  sha256 "7da150aa8e281c1323b07adca8df2bba42a323b10402930a5543d3634f44ea71"
  head "https://github.com/vgough/encfs.git"

  bottle do
    sha256 "05cbb2bdfac9bfd6bddbb48c007f6edd00cccd286c9c66addf3aaa0994e294d6" => :high_sierra
    sha256 "c2a1b09f4e54c6a5325045004d4f9eba4f4f3ac75954ab79302f22f9835ed70f" => :sierra
    sha256 "27f0e9e05a1f7eca238318e53eb6dd79a13875f84ea258250d15bf679ecc0f46" => :el_capitan
    sha256 "37dcf80058b6db6d3dd9a0b18ea71310bf731c390c658f00de13b6a1db7fe879" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gettext"
  depends_on "openssl"
  depends_on :osxfuse

  needs :cxx11

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end
