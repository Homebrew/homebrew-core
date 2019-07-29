class Minbif < Formula
  desc "IRC-to-other-IM-networks gateway using Pidgin library"
  homepage "https://symlink.me/projects/minbif/wiki/"
  url "https://deb.debian.org/debian/pool/main/m/minbif/minbif_1.0.5+git20150505.orig.tar.gz"
  version "1.0.5-20150505"
  sha256 "4e264fce518a0281de9fc3d44450677c5fa91097a0597ef7a0d2a688ee66d40b"
  revision 3

  bottle do
    cellar :any
    sha256 "479cfbb3b59f2c0c05b0553188ae2497ee313b02e5850172bb7055231def61b8" => :mojave
    sha256 "5b8a0fd609cda94163f95c7d0b6620c143b3ff127178d37a57b76493231c73cc" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "pidgin"

  def install
    inreplace "minbif.conf" do |s|
      s.gsub! "users = /var", "users = #{var}"
      s.gsub! "motd = /etc", "motd = #{etc}"
    end

    system "make", "PREFIX=#{prefix}",
                   "ENABLE_CACA=OFF",
                   "ENABLE_IMLIB=OFF",
                   "ENABLE_MINBIF=ON",
                   "ENABLE_PAM=OFF",
                   "ENABLE_PLUGIN=ON",
                   "ENABLE_TLS=ON",
                   "ENABLE_VIDEO=OFF"
    system "make", "install"

    (var/"lib/minbif/users").mkpath
  end

  def caveats; <<~EOS
    Minbif must be passed its config as first argument:
        minbif #{etc}/minbif/minbif.conf

    Learn more about minbif: https://symlink.me/projects/minbif/wiki/Quick_start
  EOS
  end

  test do
    system "#{bin}/minbif", "--version"
  end
end
