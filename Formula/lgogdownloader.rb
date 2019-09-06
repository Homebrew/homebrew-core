class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.5.tar.gz"
  sha256 "eeeaad098929a71b5fb42d14e1ca87c73fc08010ab168687bab487a763782ada"
  revision 3

  bottle do
    cellar :any
    sha256 "f7a0c21c1439fc55f7245e15dbb1baa920871bce33169c63a22478a1a10548c6" => :mojave
    sha256 "79df5c29ee1cbf3d5b6ed947742c3b3df6557bcc6ee55b034e506f553031c325" => :high_sierra
    sha256 "cb9fb9f7861b1714f13fea37f1d2c3a9be965273cf0e16e6cf04a51430104b6b" => :sierra
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
