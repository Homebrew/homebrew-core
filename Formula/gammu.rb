class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.40.0.tar.xz"
  sha256 "a760a3520d9f3a16a4ed73cefaabdbd86125bec73c6fa056ca3f0a4be8478dd6"
  revision 3
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "2101eb2a42043451ccb30f7bb2626f5d4c653ad1d025e8778155c4e26099f1b5" => :mojave
    sha256 "b7592492869a4e30486465923ac75de80ececb472caaf11315a320b68aa30a74" => :high_sierra
    sha256 "7f3e7d721eadda817e77e463bccf34fdbf2574796eefc4da53e2d2cb5ef49839" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    # Disable opportunistic linking against Postgres
    inreplace "CMakeLists.txt", "macro_optional_find_package (Postgres)", ""
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
