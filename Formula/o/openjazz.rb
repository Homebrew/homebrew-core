class Openjazz < Formula
  desc "Open source Jazz Jackrabit engine"
  homepage "https://www.alister.eu/jazz/oj/"
  url "https://github.com/AlisterT/openjazz/archive/refs/tags/20260301.tar.gz"
  sha256 "9c117a8d9aa539c4dcb3fb5788130563a83ca1d9819e538f233721d823f7a650"
  license "GPL-2.0-only"
  head "https://github.com/AlisterT/openjazz.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "6bfc89162e63bb17558bc08624c060105ff815e076fbb396d145b5e635ca2ea6"
    sha256 arm64_sequoia: "74de474ee4ceb88b075a6c6a512e3248a25c74f6009002f89dd0b156812be670"
    sha256 arm64_sonoma:  "6dd6527671c8191ea8b206a3808f10108cd56c3ce4e4cae4ecb6f3ad79304164"
    sha256 sonoma:        "12c74f58ca66e40d408c048acf972ce3ab9da5dabfc49ecfa3ea490e46e98ef3"
    sha256 arm64_linux:   "07bf3d6746df890feac5085f6172c230e4f00b316730068de499795786ff2aeb"
    sha256 x86_64_linux:  "f616f9102db1c8e95a380643842bee98afda25af124666c3b4734437070d47c6"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"
  depends_on "sdl2_net"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # From LICENSE.DOC:
  # "Epic MegaGames allows and encourages all bulletin board systems and online
  # services to distribute this game by modem as long as no files are altered
  # or removed."
  resource "shareware" do
    url "https://image.dosgamesarchive.com/games/jazz.zip"
    sha256 "ed025415c0bc5ebc3a41e7a070551bdfdfb0b65b5314241152d8bd31f87c22da"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DDATAPATH=#{pkgshare}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("shareware").stage do
      pkgshare.install Dir["*"]
    end
  end

  def caveats
    <<~EOS
      The shareware version of Jazz Jackrabbit has been installed.
      You can install the full version by copying the game files to:
        #{pkgshare}
    EOS
  end

  test do
    system bin/"OpenJazz", "--version"
    assert_path_exists testpath/"openjazz.log"
  end
end
