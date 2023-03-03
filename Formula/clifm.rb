class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.10.tar.gz"
  sha256 "b3c0bd5875009dccca8f69c6c25946f13584a34ee773af769fa53186a0e186e2"
  license "GPL-2.0-or-later"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "libmagic"
  depends_on "readline"

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--prefix", prefix
  end

  test do
    pipe_output("#{bin}/clifm --version")
  end
end
