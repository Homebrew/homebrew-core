class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.40.0.tar.xz"
  sha256 "a760a3520d9f3a16a4ed73cefaabdbd86125bec73c6fa056ca3f0a4be8478dd6"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "268a83ff9f049f11778a184dca09e7d623b9646229c29c2ec12a947225472340" => :mojave
    sha256 "11da43acbe3fc602314139531d78c5d1671667040d70f496b4222fee332bd2af" => :high_sierra
    sha256 "7dbe28490b04010a1b337e9dd4f5a9099bc1caad07f0c02de7585351978e94a1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
