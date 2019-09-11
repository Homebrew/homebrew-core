class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.5.tar.gz"
  sha256 "eeeaad098929a71b5fb42d14e1ca87c73fc08010ab168687bab487a763782ada"
  revision 4

  bottle do
    cellar :any
    sha256 "1d9727b25b3f387ac48e0e1a9c529c66fd4ce6140895c2b03db28aa75018f0e9" => :mojave
    sha256 "e9e4cf07b766149d1889e5bcccd6f2ebd621f8916e0f27462fdecc476e59050e" => :high_sierra
    sha256 "4a834c7817de61c863b8baeabaecacfcab0c68893cba3d90a6886cbde3f0f4ee" => :sierra
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
