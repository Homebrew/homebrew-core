class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.5.tar.gz"
  sha256 "eeeaad098929a71b5fb42d14e1ca87c73fc08010ab168687bab487a763782ada"
  revision 6

  bottle do
    cellar :any
    sha256 "333037e7939e4f349b7eb6715c1ea6591e1d76b55b0fa1c43fd7df2f1bde471c" => :catalina
    sha256 "1f50e4ea949c448593d140dcc28647f1fca259e535fe475876507549a5ccfbed" => :mojave
    sha256 "fefc84b1838e57dad41508f927ff70feb91ab0ce372ec2540f197774909b61d5" => :high_sierra
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
