class Nuxeo < Formula
  desc "Enterprise Content Management"
  homepage "https://nuxeo.github.io/"
  url "https://packages.nuxeo.com/repository/maven-public/org/nuxeo/ecm/distribution/nuxeo-server-tomcat/11.4.42/nuxeo-server-tomcat-11.4.42.zip"
  sha256 "38b6e7495223ff9e54857bd78fab832f1462201c713fba70a2a87d6a5d8cdd24"
  license "Apache-2.0"

  livecheck do
    url "https://doc.nuxeo.com/nxdoc/master/installing-the-nuxeo-platform-on-mac-os/"
    regex(%r{href=.*?/nuxeo-server-tomcat[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f770ff60d304faa14d16aa72548f2601afbdd6f622a5ae481aa1a460cfc19b9f"
  end

  depends_on "exiftool"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "libwpd"
  depends_on "openjdk"
  depends_on "poppler"

  def install
    libexec.install Dir["#{buildpath}/*"]

    env = Language::Java.overridable_java_home_env
    env["NUXEO_HOME"] = libexec.to_s
    env["NUXEO_CONF"] = "#{etc}/nuxeo.conf"

    chmod 0755, libexec/"bin/nuxeoctl"
    (bin/"nuxeoctl").write_env_script libexec/"bin/nuxeoctl", env

    inreplace "#{libexec}/bin/nuxeo.conf" do |s|
      s.gsub!(/#nuxeo\.log\.dir.*/, "nuxeo.log.dir=#{var}/log/nuxeo")
      s.gsub!(/#nuxeo\.data\.dir.*/, "nuxeo.data.dir=#{var}/lib/nuxeo/data")
      s.gsub!(/#nuxeo\.pid\.dir.*/, "nuxeo.pid.dir=#{var}/run/nuxeo")
    end
    etc.install "#{libexec}/bin/nuxeo.conf"

    (var/"log/nuxeo").mkpath
    (var/"lib/nuxeo/data").mkpath
    (var/"run/nuxeo").mkpath
    (var/"cache/nuxeo/packages").mkpath

    libexec.install_symlink var/"cache/nuxeo/packages"
  end

  def caveats
    <<~EOS
      You need to edit #{etc}/nuxeo.conf file to configure manually the server.
      Also, in case of upgrade, run 'nuxeoctl mp-upgrade' to ensure all
      downloaded addons are up to date.
    EOS
  end

  test do
    # Copy configuration file to test path, due to some automatic writes on it.
    cp "#{etc}/nuxeo.conf", "#{testpath}/nuxeo.conf"
    inreplace "#{testpath}/nuxeo.conf" do |s|
      s.gsub! var.to_s, testpath
      s.gsub!(/#nuxeo\.tmp\.dir.*/, "nuxeo.tmp.dir=#{testpath}/tmp")
    end

    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["NUXEO_CONF"] = "#{testpath}/nuxeo.conf"

    assert_match %r{#{testpath}/nuxeo\.conf}, shell_output("#{libexec}/bin/nuxeoctl config --get nuxeo.conf")
    assert_match libexec.to_s, shell_output("#{libexec}/bin/nuxeoctl config --get nuxeo.home")
  end
end
