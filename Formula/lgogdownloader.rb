class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.5.tar.gz"
  sha256 "eeeaad098929a71b5fb42d14e1ca87c73fc08010ab168687bab487a763782ada"
  revision 6

  bottle do
    cellar :any
    sha256 "18fa3023183d52fda887d8718e752117cc8d5b290dd324257aa3ccf4bf3408e5" => :catalina
    sha256 "e5011ad88bd93373966c069cf5eef1dc127d4fbb22fdad7b0b8a474123b1b700" => :mojave
    sha256 "c91d528e4ed9306ccd1f2558676e947671c366868b55387fe457437afb5fb3f9" => :high_sierra
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
