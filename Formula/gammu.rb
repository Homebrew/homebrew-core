class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.40.0.tar.xz"
  sha256 "a760a3520d9f3a16a4ed73cefaabdbd86125bec73c6fa056ca3f0a4be8478dd6"
  revision 2
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "024da26d637286903f0456997dc4d0231f8163163106d23fae95085e33cb7862" => :mojave
    sha256 "1cb822252b422c771c13a5283cd6a1ea3283cb6d897adc730e7631ad1a788cfa" => :high_sierra
    sha256 "2da2dba2c832236e0c2ef1bb43fdd4fa96dd3862868b0ef7cf009c62986f8390" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "openssl"

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
