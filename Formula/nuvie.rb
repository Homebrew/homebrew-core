class Nuvie < Formula
  desc "The Ultima 6 engine"
  homepage "https://nuvie.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nuvie/Nuvie/0.5/nuvie-0.5.tgz"
  sha256 "ff026f6d569d006d9fe954f44fdf0c2276dbf129b0fc5c0d4ef8dce01f0fc257"

  bottle do
    sha256 "482181b9e3badb5e1c1d4b22176b7c2b48bc28cf3d96034291a8833fb9aecebf" => :mojave
    sha256 "f6f5c6e9396e6a8920ce10765807c07c8aea1158b18807087ece931cbe428948" => :high_sierra
    sha256 "036ab5e7a6b95f33f470c00124cc498012f38e650b830eca1d84082a7296a554" => :sierra
    sha256 "bbf72ee5eeb816255999fc5c331bc70d6b4af3a7f639795f736b8f46e70b9790" => :el_capitan
    sha256 "324dcf4a9f1ae523fd70fbbb1141f7cfe4245348d439c37dbe7a1520eb9e00d9" => :yosemite
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

  def caveats; <<~EOS
    Copy your Ultima 6 game files into the following directory:
      #{var}/nuvie/game/ultima6/
    Save games will be stored in the following directory:
      #{var}/nuvie/savegames/
    Config file will be located at:
      #{var}/nuvie/nuvie.cfg
  EOS
  end
end
