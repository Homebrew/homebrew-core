class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://files.i2p-projekt.de/1.7.0/i2psource_1.7.0.tar.bz2"
  sha256 "aa53591e89eacc3491ab472dc4df998780fb6747eea3b97ecb7a9f81ff2c9a5e"

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d302e20bd89ac2bcb01b2111a7964488c07f2260c09679cf84d5ffb9ff3803d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "114ed5161b0ba22d6bcbd43e0fda089fcf23eeb27cc8306ec8c199a94ec91c27"
    sha256 cellar: :any_skip_relocation, monterey:       "547b2552a32ab73dc44f07befa1cce637a97bfd854fcb5793dbab5097f776080"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0847c5266cd4b62b4a4de3271538f3085a1575bb5c896fb29bd175c03972033"
    sha256 cellar: :any_skip_relocation, catalina:       "97ae946092a65cb9c864d58cb13a30b73163eba6f7b98644684a2c51a3acffc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c292be9e1b180996d7df96c0554e631ba92374f6e436f518a44f4b617e9fc987"
  end

  depends_on "ant" => :build
  depends_on "gettext" => :build
  depends_on "java-service-wrapper"
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    system "ant", "preppkg-#{os}-only"

    libexec.install (buildpath/"pkg-temp").children

    # Replace vendored copy of java-service-wrapper with brewed version.
    rm libexec/"lib/wrapper.jar"
    rm_rf libexec/"lib/wrapper"
    jsw_libexec = Formula["java-service-wrapper"].opt_libexec
    ln_s jsw_libexec/"lib/wrapper.jar", libexec/"lib"
    ln_s jsw_libexec/"lib/#{shared_library("libwrapper")}", libexec/"lib"
    cp jsw_libexec/"bin/wrapper", libexec/"i2psvc" # Binary must be copied, not symlinked.

    # Set executable permissions on scripts
    scripts = ["eepget", "i2prouter", "runplain.sh"]
    scripts += ["install_i2p_service_osx.command", "uninstall_i2p_service_osx.command"] if OS.mac?

    scripts.each do |file|
      chmod 0755, libexec/file
    end

    # Replace references to INSTALL_PATH with libexec
    install_path_files = ["eepget", "i2prouter", "runplain.sh"]
    install_path_files << "Start I2P Router.app/Contents/MacOS/i2prouter" if OS.mac?
    install_path_files.each do |file|
      inreplace libexec/file, "%INSTALL_PATH", libexec
    end

    inreplace libexec/"wrapper.config", "$INSTALL_PATH", libexec

    # Wrap eepget and i2prouter in env scripts so they can find OpenJDK
    (bin/"eepget").write_env_script libexec/"eepget", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin/"i2prouter").write_env_script libexec/"i2prouter", JAVA_HOME: Formula["openjdk"].opt_prefix
    man1.install Dir["#{libexec}/man/*"]
  end

  test do
    assert_match "I2P Service is not running.", shell_output("#{bin}/i2prouter status", 1)
  end
end
