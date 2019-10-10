class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/icecast/icecast-2.4.3.tar.gz"
  sha256 "c85ca48c765d61007573ee1406a797ae6cb31fb5961a42e7f1c87adb45ddc592"
  revision 1

  bottle do
    cellar :any
    sha256 "801fe26cf88ab2ec80acd3d4ecdc4590fcdc7f056f5c33da9237d3c61a523bc5" => :catalina
    sha256 "ac73db76265cce7244bf2e0c5b16de50c94a5161ce34e24062e3e135ccf8b1bb" => :mojave
    sha256 "8b1366feb5df71dd1702a6ebcf990e15b32c0b0220a23a8c8336cf0244c7dfac" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "openssl@1.1"
  uses_from_macos "curl"
  uses_from_macos "libxslt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    (prefix+"var/log/icecast").mkpath
    touch prefix+"var/log/icecast/error.log"
  end
end
