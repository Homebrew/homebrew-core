class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.3.tar.gz"
  sha256 "7da150aa8e281c1323b07adca8df2bba42a323b10402930a5543d3634f44ea71"
  head "https://github.com/vgough/encfs.git"

  bottle do
    sha256 "4fe8170189664573b9f38d4397689f9c0564ac88a5a531755f6dc9bca8025cb9" => :high_sierra
    sha256 "04ed26da2ec5b26a1862c40167eceb064b27cfaf4e2027c4b38e86713979b7aa" => :sierra
    sha256 "34f6417041963eb692491d896467c8e9eff041d7c2ddcf6291a75397c111d4df" => :el_capitan
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
