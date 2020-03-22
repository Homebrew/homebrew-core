class Nuxeo < Formula
  desc "Enterprise Content Management"
  homepage "https://nuxeo.github.io/"
  url "https://cdn.nuxeo.com/nuxeo-10.10/nuxeo-server-10.10-tomcat.zip"
  sha256 "93a923a6e654d216a57fc91767a428e8c22cf5a879f264474f8976016e34ca6f"

  bottle :unneeded

  depends_on "exiftool"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "libwpd"
  depends_on "poppler"
  depends_on "ufraw"

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
      s.gsub! /#{var}/, testpath
      s.gsub! /#nuxeo\.tmp\.dir.*/, "nuxeo.tmp.dir=#{testpath}/tmp"
    end

    ENV["NUXEO_CONF"] = "#{testpath}/nuxeo.conf"

    assert_match %r{#{testpath}/nuxeo\.conf}, shell_output("#{libexec}/bin/nuxeoctl config -q --get nuxeo.conf")
    assert_match /#{libexec}/, shell_output("#{libexec}/bin/nuxeoctl config -q --get nuxeo.home")
  end
end
