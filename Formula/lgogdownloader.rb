class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.7.tar.gz"
  sha256 "984859eb2e0802cfe6fe76b1fe4b90e7354e95d52c001b6b434e0a9f5ed23bf0"
  revision 2

  bottle do
    cellar :any
    sha256 "88fff1ac2d05e20e302ad14f31ac73871b3ff26d2b54c781da39dc0a97f4cd52" => :catalina
    sha256 "76aea029305b9895f01a1caf899323f728a9a97c3c7274c8574ad3acd83b00e7" => :mojave
    sha256 "82185cd04819b89b35d6b7736c75fb07d12edb269ba08d7df7bfa2a15000d040" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "htmlcxx"
  depends_on "jsoncpp"
  depends_on "liboauth"
  depends_on "rhash"
  depends_on "tinyxml2"

  def install
    system "cmake", ".", *std_cmake_args, "-DJSONCPP_INCLUDE_DIR=#{Formula["jsoncpp"].opt_include}"

    system "make", "install"
  end

  test do
    require "pty"

    ENV["XDG_CONFIG_HOME"] = testpath
    reader, writer = PTY.spawn(bin/"lgogdownloader", "--list", "--retries", "1")
    writer.write <<~EOS
      test@example.com
      secret
    EOS
    writer.close
    assert_equal "HTTP: Login failed", reader.read.lines.last.chomp
    reader.close
  end
end
