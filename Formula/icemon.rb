class Icemon < Formula
  desc "Icecream GUI Monitor"
  homepage "https://github.com/icecc/icemon"
  url "https://github.com/icecc/icemon/archive/v3.2.0.tar.gz"
  sha256 "b7ed29c3638c93fbc974d56c85afbf0bfeca6c37ed0522af57415a072839b448"

  bottle do
    cellar :any
    sha256 "45f7516bfe7650c8241da282b864e4e8e87f1086dc73b6536a505a70483812c6" => :mojave
    sha256 "091c0de73c69ae36a5bff744e7cf81b2321630f3499d67de139cea5782e3b0a0" => :high_sierra
    sha256 "8f4bb166755f10d04f3a20e5792ed108c86286e4451a7e87b79864835732e78d" => :sierra
    sha256 "7422122b9818ac86761695845bb7e4a63abfd483d9959b26570f9624569442c3" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icecream"
  depends_on "lzo"
  depends_on "qt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/icemon", "--version"
  end
end
