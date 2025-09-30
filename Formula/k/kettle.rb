class Kettle < Formula
  desc "Pentaho Data Integration software"
  homepage "https://pentaho.com/products/pentaho-data-integration"
  url "https://hitachiedge1.jfrog.io/artifactory/pntpub-maven-release/org/pentaho/di/pdi-ce/9.4.0.0-343/pdi-ce-9.4.0.0-343.zip"
  sha256 "e6804fae1a9aa66b92e781e9b2e835d72d56a6adc53dc03e429a847991a334e8"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "2e06b9a8ce68da482615fb8566137223350e711a6d7a48e8e19f27bb3307b0f7"
  end

  # https://www.linkedin.com/pulse/license-changes-pentaho-community-edition-from-version-philipp-heck-3kzwe
  deprecate! date: "2025-09-19", because: "changed its license to BUSL on the next release"
  disable! date: "2026-09-19", because: "changed its license to BUSL on the next release"

  depends_on "openjdk"

  def install
    rm_r(Dir["*.{bat}"])
    libexec.install Dir["*"]

    (etc+"kettle").install libexec/"pwd/carte-config-master-8080.xml" => "carte-config.xml"
    (etc+"kettle/.kettle").install libexec/"pwd/kettle.pwd"
    (etc+"kettle/simple-jndi").mkpath

    (var+"log/kettle").mkpath

    # We don't assume that carte, kitchen or pan are in anyway unique command names so we'll prepend "pdi"
    env = { BASEDIR: libexec, JAVA_HOME: Language::Java.java_home }
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
    system bin/"pdipan", "-file=#{libexec}/samples/transformations/Encrypt Password.ktr", "-level=RowLevel"
  end
end
