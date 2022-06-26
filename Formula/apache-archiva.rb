class ApacheArchiva < Formula
  desc "Build Artifact Repository Manager"
  homepage "https://archiva.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=archiva/2.2.8/binaries/apache-archiva-2.2.8-bin.tar.gz"
  mirror "https://archive.apache.org/dist/archiva/2.2.8/binaries/apache-archiva-2.2.8-bin.tar.gz"
  sha256 "8ef2c2b866260de1102db39929902d6f8365492a0ac12c1300f937ae9f65da31"
  license all_of: ["Apache-2.0", "GPL-2.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26714e5d6850b4e9636407601d0c3abd7c66e010c8c7ce47ad1f3930309eedb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26714e5d6850b4e9636407601d0c3abd7c66e010c8c7ce47ad1f3930309eedb9"
    sha256 cellar: :any_skip_relocation, monterey:       "26714e5d6850b4e9636407601d0c3abd7c66e010c8c7ce47ad1f3930309eedb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "26714e5d6850b4e9636407601d0c3abd7c66e010c8c7ce47ad1f3930309eedb9"
    sha256 cellar: :any_skip_relocation, catalina:       "26714e5d6850b4e9636407601d0c3abd7c66e010c8c7ce47ad1f3930309eedb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0df59cf09aa5511494063569457fcc82c256b53e87005be3101455fc737b5b6c"
  end

  depends_on "ant" => :build
  depends_on "java-service-wrapper"
  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    rm_f libexec.glob("bin/wrapper*")
    rm_f libexec.glob("lib/libwrapper*")
    (bin/"archiva").write_env_script libexec/"bin/archiva", Language::Java.java_home_env

    wrapper = Formula["java-service-wrapper"].opt_libexec
    ln_sf wrapper/"bin/wrapper", libexec/"bin/wrapper"
    libext = OS.mac? ? "jnilib" : "so"
    ln_sf wrapper/"lib/libwrapper.#{libext}", libexec/"lib/libwrapper.#{libext}"
    ln_sf wrapper/"lib/wrapper.jar", libexec/"lib/wrapper.jar"
  end

  def post_install
    (var/"archiva/logs").mkpath
    (var/"archiva/data").mkpath
    (var/"archiva/temp").mkpath

    cp_r libexec/"conf", var/"archiva"
  end

  service do
    run [opt_bin/"archiva", "console"]
    environment_variables ARCHIVA_BASE: var/"archiva"
    log_path var/"archiva/logs/launchd.log"
  end

  test do
    assert_match "was not running.", shell_output("#{bin}/archiva stop")
  end
end
