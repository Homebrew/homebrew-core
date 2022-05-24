class ApacheArchiva < Formula
  desc "Build Artifact Repository Manager"
  homepage "https://archiva.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=archiva/2.2.7/binaries/apache-archiva-2.2.7-bin.tar.gz"
  mirror "https://archive.apache.org/dist/archiva/2.2.7/binaries/apache-archiva-2.2.7-bin.tar.gz"
  sha256 "ce3dd01c38f5ef238532ac7541d866eb7171297a9275eb10aabc17e15e7907d2"
  license all_of: ["Apache-2.0", "GPL-2.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f2c9b928b00301fbeb33b6d46da7b2cc99a8f23148fb90375c0b49e3d6a29db"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f2c9b928b00301fbeb33b6d46da7b2cc99a8f23148fb90375c0b49e3d6a29db"
    sha256 cellar: :any_skip_relocation, catalina:      "9f2c9b928b00301fbeb33b6d46da7b2cc99a8f23148fb90375c0b49e3d6a29db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1a332b831184b3109efccc2daf714e71cad14b82cd799c15ad6a2772584167d"
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
