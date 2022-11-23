class Kettle < Formula
  desc "Pentaho Data Integration software"
  homepage "https://www.hitachivantara.com/en-us/products/data-management-analytics.html"
  url "https://downloads.sourceforge.net/project/pentaho/Pentaho-9.3/client-tools/pdi-ce-9.3.0.0-428.zip"
  sha256 "5c7a453ec448d4b8a568e445b119bcf4f0f41517b42e3626bc437f882c9f46c1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/pdi-ce[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16ad24ced055df02d5e8966613d3454cddccfd96fc0b3f71de1f9c6c4bcccedb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba4505bc117fbad7cec2d0e9421062f018b2f749256c478e8aad75e79bba065c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba4505bc117fbad7cec2d0e9421062f018b2f749256c478e8aad75e79bba065c"
    sha256 cellar: :any_skip_relocation, ventura:        "7a10323362d55ad5a514ac21f50894da0c0970eef157dfa403895a3df22cceda"
    sha256 cellar: :any_skip_relocation, monterey:       "c4ad0f19a4e41e7d86694e6835fbd6072879419e34c4bfab1ab55ee664ffeced"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4ad0f19a4e41e7d86694e6835fbd6072879419e34c4bfab1ab55ee664ffeced"
    sha256 cellar: :any_skip_relocation, catalina:       "c4ad0f19a4e41e7d86694e6835fbd6072879419e34c4bfab1ab55ee664ffeced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba4505bc117fbad7cec2d0e9421062f018b2f749256c478e8aad75e79bba065c"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["*.{bat}"]
    libexec.install Dir["*"]

    (etc+"kettle").install libexec+"pwd/carte-config-master-8080.xml" => "carte-config.xml"
    (etc+"kettle/.kettle").install libexec+"pwd/kettle.pwd"
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
    system "#{bin}/pdipan", "-file=#{libexec}/samples/transformations/Encrypt\ Password.ktr", "-level=RowLevel"
  end
end
