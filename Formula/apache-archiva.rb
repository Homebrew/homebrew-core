class ApacheArchiva < Formula
  desc "Build Artifact Repository Manager"
  homepage "https://archiva.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=archiva/2.2.6/binaries/apache-archiva-2.2.6-bin.tar.gz"
  mirror "https://archive.apache.org/dist/archiva/2.2.6/binaries/apache-archiva-2.2.6-bin.tar.gz"
  sha256 "407490ca925a3b128ddf528bc9574f9284ae4d99d37031215c85a7713c5593c6"
  license all_of: ["Apache-2.0", "GPL-2.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aaaa03ae8f9cbafef6a26cdc3c25607c79b7706084a4f88a2982a7e145091819"
    sha256 cellar: :any_skip_relocation, big_sur:       "aaaa03ae8f9cbafef6a26cdc3c25607c79b7706084a4f88a2982a7e145091819"
    sha256 cellar: :any_skip_relocation, catalina:      "aaaa03ae8f9cbafef6a26cdc3c25607c79b7706084a4f88a2982a7e145091819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f813febed2dba705cfd48f49c6350861bf62a1271c8543b1f548c96d47770fe"
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
