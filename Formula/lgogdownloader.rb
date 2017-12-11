class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.3.tar.gz"
  sha256 "8bb7a37b48f558bddeb662ebac32796b0ae11fa2cc57a03d48b3944198e800ce"
  revision 1

  bottle do
    cellar :any
    sha256 "e6c9574ff1cb845ce17c44d507bd5a11281c41b22bb665efe5286b07b083a7d9" => :high_sierra
    sha256 "ea2ccb5d756bca5c93969322d2170f8fcf55e87af709785e42fac8ab49db5083" => :sierra
    sha256 "4d9daf883967e1ba1ad1902ce0f52b624627f922c9102917b38c916a1f070910" => :el_capitan
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
    system "cmake", ".", *std_cmake_args
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
