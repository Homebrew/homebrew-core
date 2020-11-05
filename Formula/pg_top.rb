class PgTop < Formula
  desc "Monitor PostgreSQL processes"
  homepage "https://pg_top.gitlab.io"
  url "https://pg_top.gitlab.io/source/pg_top-4.0.0.tar.xz"
  sha256 "5191765f6be187725f0decbbe9ae85af1c4354f69d2e1364a6415846652c2825"
  license "BSD-3-Clause"
  head "https://gitlab.com/pg_top/pg_top.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "a8bd95ff06d4f746e3763933fee8f4118b5ae6e3d16c4a8e2ff1bc675bd4091a" => :catalina
    sha256 "d31b2fb44c6d363f0f635bf6a16427968ca610ea285569bfa867bea6d0437549" => :mojave
    sha256 "32637c635d8da78d4910df2dabd474f4115c31cba57890ad053b3a43cb38a758" => :high_sierra
    sha256 "5f06ae8b8ef1c979143e19c0527c31c8d649d23e1e9612c63bc6c5ff05bf8276" => :sierra
    sha256 "6d0104d461d7187ad02e1085098f2dad4fa00c4f2db93b1b910a6a072517ca54" => :el_capitan
  end

  depends_on "cmake" => :build

  depends_on "postgresql"

  def install
    mv "machine/m_macosx.c", "machine/m_darwin.c"
    inreplace "CMakeLists.txt", "/usr/include/", "#{MacOS.sdk_path}/usr/include/"
    inreplace "machine/m_remote.c",
      "#if defined(__FreeBSD__) || defined(__OpenBSD__)",
      "#if defined(__FreeBSD__) || defined(__OpenBSD__) || defined(__APPLE__)"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pg_top -V")
  end
end
