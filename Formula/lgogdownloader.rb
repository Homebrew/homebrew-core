class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.3.tar.gz"
  sha256 "8bb7a37b48f558bddeb662ebac32796b0ae11fa2cc57a03d48b3944198e800ce"
  revision 6

  bottle do
    cellar :any
    sha256 "e7315e44ac18f84a331f6677340d5aff7d36617f820b7453ace24ce88bbc4e9e" => :mojave
    sha256 "44a1422230e4b6170e8a3eeac6e8234d4e723ccd0d8b7e7a1c9bdae23bb0fede" => :high_sierra
    sha256 "deef377b72952203676140e50a7ea143b4c2aa10bd6cf8a04b233e890aebc12f" => :sierra
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
