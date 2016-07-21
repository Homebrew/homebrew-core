class Nuxeo < Formula
  desc "Enterprise Content Management"
  homepage "https://nuxeo.github.io/"
  url "https://cdn.nuxeo.com/nuxeo-8.3/nuxeo-cap-8.3-tomcat.zip"
  version "8.3"
  sha256 "6de18ffa1737d6ef3fb9561f6c35f3200cfeedc7e7693e424ce31396eb42206c"

  bottle do
    cellar :any_skip_relocation
    sha256 "41eceb5b761f78e2cac1c64e3687db41aed82c7720d85813e25416e039edc3fd" => :el_capitan
    sha256 "fd565b9b3beb86ab6ff4b3e8869fe666d258899cc5e43cd269ae34fb4fa0398b" => :yosemite
    sha256 "03a8a8ec9a98dbf07f03c56f68f58c476297035477e9ba712075a93e418ce9b7" => :mavericks
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
