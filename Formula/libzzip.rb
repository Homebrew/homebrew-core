class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.71.tar.gz"
  sha256 "2ee1e0fbbb78ec7cc46bde5b62857bc51f8d665dd265577cf93584344b8b9de2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "aab2e4b218f21888c92b055fff7d801ea4511b4d133517cf4d5696bea0fb54e7" => :catalina
    sha256 "2e293f90e2ebee0734ff9bb6a23cdcd562383d87e801de996f57296aef3a15b4" => :mojave
    sha256 "7ae8222e9b3f3d56639d19de2666eb1dffb6399d5985a64f52a24cdbe3763b58" => :high_sierra
    sha256 "72c6927e722159e240f313b0bbc5dfd7648b340fd7a9c732d99e9eeaac6d4945" => :sierra
    sha256 "2ed4dd48a0e3ae9b528164456652b0d5e8730153c398b6441a1ffb7d44e45f4d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DZZIPSDL=OFF"
      system "make", "man"
      system "make", "install"
    end
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "/usr/bin/zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
