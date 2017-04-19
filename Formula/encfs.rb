class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.1.tar.gz"
  sha256 "67203aeff7a06ce7be83df4948db296be89a00cffe1108a0a41c96d7481106a4"
  head "https://github.com/vgough/encfs.git"

  bottle do
    sha256 "8329a0a80ee9ce5f54c211c95233755f5636f78088fee492340d80d64a1b08ed" => :sierra
    sha256 "b1bf8ed2da863b827d0f8c15d3d27aef446351830e336afec49d75e0be209a56" => :el_capitan
    sha256 "38595ac5d8fedd8544fee9989f2bd68196c091df9a7bcd7e9e494952e8d3843a" => :yosemite
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
