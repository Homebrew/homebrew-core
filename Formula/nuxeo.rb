class Nuxeo < Formula
  desc "Enterprise Content Management"
  homepage "https://nuxeo.github.io/"
  url "https://cdn.nuxeo.com/nuxeo-8.2/nuxeo-cap-8.2-tomcat.zip"
  version "8.2"
  sha256 "3df6d9847a7ec22da75f6a5e3dd8dbeebcf8b5534c3ecc93bec20008bc7b106b"

  bottle do
    cellar :any_skip_relocation
    sha256 "51d9badd3c8578dcf98eb7d23a704f84448b29267f292de47523ff5f048147ec" => :el_capitan
    sha256 "5ea1a7cbfb060fd7c42cc19cb8518aa54c51484538a330e7b0d94719da036c44" => :yosemite
    sha256 "221b44c5b6096e2eb394ad6304206f51013b3f34e4bde946b60e75d79413a8d9" => :mavericks
  end

  depends_on "poppler" => :recommended
  depends_on "pdftohtml" => :optional
  depends_on "imagemagick"
  depends_on "ghostscript"
  depends_on "ufraw"
  depends_on "libwpd"
  depends_on "exiftool"
  depends_on "ffmpeg" => :optional

  def install
    libexec.install Dir["#{buildpath}/*"]

    (bin/"nuxeoctl").write_env_script "#{libexec}/bin/nuxeoctl",
      :NUXEO_HOME => libexec.to_s, :NUXEO_CONF => "#{etc}/nuxeo.conf"

    inreplace "#{libexec}/bin/nuxeo.conf" do |s|
      s.gsub! /#nuxeo\.log\.dir.*/, "nuxeo.log.dir=#{var}/log/nuxeo"
      s.gsub! /#nuxeo\.data\.dir.*/, "nuxeo.data.dir=#{var}/lib/nuxeo/data"
      s.gsub! /#nuxeo\.pid\.dir.*/, "nuxeo.pid.dir=#{var}/run/nuxeo"
    end
    etc.install "#{libexec}/bin/nuxeo.conf"
  end

  def post_install
    (var/"log/nuxeo").mkpath
    (var/"lib/nuxeo/data").mkpath
    (var/"run/nuxeo").mkpath
    (var/"cache/nuxeo/packages").mkpath

    libexec.install_symlink var/"cache/nuxeo/packages"
  end

  def caveats; <<-EOS.undent
    You need to edit #{etc}/nuxeo.conf file to configure manually the server.
    Also, in case of upgrade, run 'nuxeoctl mp-upgrade' to ensure all
    downloaded addons are up to date.
    EOS
  end

  test do
    # Copy configuration file to test path, due to some automatic writes on it.
    cp "#{etc}/nuxeo.conf", "#{testpath}/nuxeo.conf"
    inreplace "#{testpath}/nuxeo.conf" do |s|
      s.gsub! /#{var}/, testpath
      s.gsub! /#nuxeo\.tmp\.dir.*/, "nuxeo.tmp.dir=#{testpath}/tmp"
    end

    ENV["NUXEO_CONF"] = "#{testpath}/nuxeo.conf"

    assert_match %r{#{testpath}/nuxeo\.conf}, shell_output("#{libexec}/bin/nuxeoctl config -q --get nuxeo.conf")
    assert_match /#{libexec}/, shell_output("#{libexec}/bin/nuxeoctl config -q --get nuxeo.home")
  end
end
