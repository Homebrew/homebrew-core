class Kettle < Formula
  desc "Pentaho Data Integration software"
  homepage "https://www.hitachivantara.com/en-us/products/data-management-analytics.html"
  url "https://downloads.sourceforge.net/project/pentaho/Pentaho-9.2/client-tools/pdi-ce-9.2.0.0-290.zip"
  sha256 "8e64d1125b2403df66f212488762f1558968a3900d079c730b2f6943e346a7e7"

  livecheck do
    url :stable
    regex(%r{url=.*?/pdi-ce[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.(?:t|zip)}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "0ccda9f659deb86487578d026cf3e82dfd26bd2c3850d6ef486c6fa2d44de07f"
  end

  depends_on "openjdk@8"

  def install
    rm_rf Dir["*.{bat}"]
    libexec.install Dir["*"]

    (etc+"kettle").install libexec+"pwd/carte-config-master-8080.xml" => "carte-config.xml"
    (etc+"kettle/.kettle").install libexec+"pwd/kettle.pwd"
    (etc+"kettle/simple-jndi").mkpath

    (var+"log/kettle").mkpath

    # We don't assume that carte, kitchen or pan are in anyway unique command names so we'll prepend "pdi"
    env = { BASEDIR: libexec, JAVA_HOME: Language::Java.java_home("1.8") }
    %w[carte kitchen pan].each do |command|
      (bin+"pdi#{command}").write_env_script libexec+"#{command}.sh", env
    end
  end

  service do
    run [opt_bin/"pdicarte", etc/"kettle/carte-config.xml"]
    working_dir etc/"kettle"
    log_path var/"log/kettle/carte.log"
    error_log_path var/"log/kettle/carte.log"
    environment_variables KETTLE_HOME: etc/"kettle"
  end

  test do
    system "#{bin}/pdipan", "-file=#{libexec}/samples/transformations/Encrypt\ Password.ktr", "-level=RowLevel"
  end
end
