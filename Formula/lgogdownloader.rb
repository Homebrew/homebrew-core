class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.6.tar.gz"
  sha256 "95dc314159e5bde638e0f2e78b0ba66dea935d0fa0047eefd055e05f7aa25ac1"

  bottle do
    cellar :any
    sha256 "0b4c2d24759e18abd6c59eb922d42c406830a46a627bbf1897f84e57c047b75c" => :catalina
    sha256 "b66ca47c47627faa0ea1c3e46f3adaae95b23c43f93c3ac95af29820ed2ecbe0" => :mojave
    sha256 "29cfb7ecc89bbe98d88991b999654b26e604032c8efb16e0a581284a557d70c0" => :high_sierra
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
