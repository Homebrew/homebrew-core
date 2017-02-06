class Nuvie < Formula
  desc "The Ultima 6 engine"
  homepage "http://nuvie.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nuvie/Nuvie/0.5/nuvie-0.5.tgz"
  sha256 "ff026f6d569d006d9fe954f44fdf0c2276dbf129b0fc5c0d4ef8dce01f0fc257"

  bottle do
    sha256 "c0c3f49017d8aca42f7abf1681db052d699585741aad47ae9c92f19f1aa9208c" => :yosemite
    sha256 "cf1ca12f0dc0fdf4b26fb53be5899b979eb277005de257e94c5b1509d53cf2eb" => :mavericks
    sha256 "b44e21612d24b3f2552f342f445408a19b82449e5686c1b40b1c72686fe20b09" => :mountain_lion
  end

  head do
    url "https://github.com/nuvie/nuvie.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "sdl"

  def install
    inreplace "./nuvie.cpp" do |s|
      s.gsub! 'datadir", "./data"', "datadir\", \"#{lib}/data\""
      s.gsub! 'home + "/Library', '"/Library'
      s.gsub! 'config_path.append("/Library/Preferences/Nuvie Preferences");', "config_path = \"#{var}/nuvie/nuvie.cfg\";"
      s.gsub! "/Library/Application Support/Nuvie Support/", "#{var}/nuvie/game/"
      s.gsub! "/Library/Application Support/Nuvie/", "#{var}/nuvie/"
    end
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "nuvie"
    pkgshare.install "data"
  end

  def post_install
    (var/"nuvie/game").mkpath
  end

  def caveats; <<-EOS.undent
    Copy your Ultima 6 game files into the following directory:
      #{var}/nuvie/game/ultima6/
    Save games will be stored in the following directory:
      #{var}/nuvie/savegames/
    Config file will be located at:
      #{var}/nuvie/nuvie.cfg
    EOS
  end
end
