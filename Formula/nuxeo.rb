class Nuxeo < Formula
  desc "Enterprise Content Management"
  homepage "https://nuxeo.github.io/"
  url "https://cdn.nuxeo.com/nuxeo-10.10/nuxeo-server-10.10-tomcat.zip"
  sha256 "93a923a6e654d216a57fc91767a428e8c22cf5a879f264474f8976016e34ca6f"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3c4a5916ae6ddbd2f1294d1445429febf7f4ee4b674a72239a39f2183d9703c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af8bae41aea48c4ab4475b64db647cf40a060790cc5b6b4c699c7e2578afdf9d"
    sha256 cellar: :any_skip_relocation, monterey:       "0e48e72151f61aab63503e16443c02acafb2411edff0e6380db3ed654c0f3ad5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5322ea1c6ff309613ecd84d788bf56b0590c83cd9e1d5f1d8f3ef99c1610baa6"
    sha256 cellar: :any_skip_relocation, catalina:       "5322ea1c6ff309613ecd84d788bf56b0590c83cd9e1d5f1d8f3ef99c1610baa6"
    sha256 cellar: :any_skip_relocation, mojave:         "5322ea1c6ff309613ecd84d788bf56b0590c83cd9e1d5f1d8f3ef99c1610baa6"
  end

  depends_on "exiftool"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "libwpd"
  depends_on "openjdk"
  depends_on "poppler"
  depends_on "ufraw"

  def install
    libexec.install Dir["#{buildpath}/*"]

    env = Language::Java.overridable_java_home_env
    env["NUXEO_HOME"] = libexec.to_s
    env["NUXEO_CONF"] = "#{etc}/nuxeo.conf"

    (bin/"nuxeoctl").write_env_script "#{libexec}/bin/nuxeoctl", env

    inreplace "#{libexec}/bin/nuxeo.conf" do |s|
      s.gsub!(/#nuxeo\.log\.dir.*/, "nuxeo.log.dir=#{var}/log/nuxeo")
      s.gsub!(/#nuxeo\.data\.dir.*/, "nuxeo.data.dir=#{var}/lib/nuxeo/data")
      s.gsub!(/#nuxeo\.pid\.dir.*/, "nuxeo.pid.dir=#{var}/run/nuxeo")
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
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    # Copy configuration file to test path, due to some automatic writes on it.
    cp "#{etc}/nuxeo.conf", "#{testpath}/nuxeo.conf"
    inreplace "#{testpath}/nuxeo.conf" do |s|
      s.gsub! var.to_s, testpath
      s.gsub!(/#nuxeo\.tmp\.dir.*/, "nuxeo.tmp.dir=#{testpath}/tmp")
    end

    ENV["NUXEO_CONF"] = "#{testpath}/nuxeo.conf"

    assert_match %r{#{testpath}/nuxeo\.conf}, shell_output("#{libexec}/bin/nuxeoctl config -q --get nuxeo.conf")
    assert_match libexec.to_s, shell_output("#{libexec}/bin/nuxeoctl config -q --get nuxeo.home")
  end
end
