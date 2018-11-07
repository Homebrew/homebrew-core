class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.3.tar.gz"
  sha256 "8bb7a37b48f558bddeb662ebac32796b0ae11fa2cc57a03d48b3944198e800ce"
  revision 4

  bottle do
    cellar :any
    sha256 "945f00e28f4e3112dd6b70e3293059e00c31a8b23dbbc900f4b54b405519ab2a" => :mojave
    sha256 "637ec4a70e27d7e1f3a0a2d81623dc77a805a7a356444a8101ac47a2afed0543" => :high_sierra
    sha256 "1cdce4d683962f19fdd7e0f7186fd6b1c8e7648562f591294dbd0c4dbdc01963" => :sierra
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
