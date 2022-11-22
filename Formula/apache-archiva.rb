class ApacheArchiva < Formula
  desc "Build Artifact Repository Manager"
  homepage "https://archiva.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=archiva/2.2.9/binaries/apache-archiva-2.2.9-bin.tar.gz"
  mirror "https://archive.apache.org/dist/archiva/2.2.9/binaries/apache-archiva-2.2.9-bin.tar.gz"
  sha256 "183f00be4b05564e01c9a4687b59d81828d9881c55289e0a2a9c1f903afb0c93"
  license all_of: ["Apache-2.0", "GPL-2.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef05037f1f5a15705135782387ebf8f96b0f10d00ccf682ead0dc2ff2c58e5ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef05037f1f5a15705135782387ebf8f96b0f10d00ccf682ead0dc2ff2c58e5ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef05037f1f5a15705135782387ebf8f96b0f10d00ccf682ead0dc2ff2c58e5ab"
    sha256 cellar: :any_skip_relocation, ventura:        "ef05037f1f5a15705135782387ebf8f96b0f10d00ccf682ead0dc2ff2c58e5ab"
    sha256 cellar: :any_skip_relocation, monterey:       "ef05037f1f5a15705135782387ebf8f96b0f10d00ccf682ead0dc2ff2c58e5ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef05037f1f5a15705135782387ebf8f96b0f10d00ccf682ead0dc2ff2c58e5ab"
    sha256 cellar: :any_skip_relocation, catalina:       "ef05037f1f5a15705135782387ebf8f96b0f10d00ccf682ead0dc2ff2c58e5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "887eb08cf917193dc9c0b72823baeff7fcd8a9f9eefd95ca7714e09e01b764cd"
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
