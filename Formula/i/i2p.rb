class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://github.com/i2p/i2p.i2p/archive/refs/tags/i2p-2.8.2.tar.gz"
  sha256 "b259b5a7d4652dc344b106d00223d1a6c53339d3a126aed2428a56806044d464"
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^i2p[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0474f0fe1bb56848164ead49ae8fc6773411c03a89deca2d2bab927818d6c3e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dc4c1f910162f8b9ad1f918bf6e3e3b79c8a859b5c63baa2be55387acddc49a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c2ab69384a69e6789a5d94c42e9db014a13e4246a6883fc77a71e24db197c84"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ba3aa0abed7cf698f49358c49e17f95a1147d1016edd0fa9280b199a433fec2"
    sha256 cellar: :any_skip_relocation, ventura:       "883859807c878a8335a3ea00fc89fc705ca66a725ea1c87809253541398450d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a713439beb9052582edac83adc9afb95aeb729020b7094d0a1b6146cd44cf11f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d8af5e63ed68d9755a4e29419295bba255ea6915f43393670b16ee027565d71"
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
    rm_r(libexec/"lib/wrapper")
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

    inreplace libexec/"i2prouter", "%USER_HOME", "$HOME"
    inreplace libexec/"i2prouter", "%SYSTEM_java_io_tmpdir", "$TMPDIR"
    inreplace libexec/"runplain.sh", "%SYSTEM_java_io_tmpdir", "$TMPDIR"

    # Wrap eepget and i2prouter in env scripts so they can find OpenJDK
    (bin/"eepget").write_env_script libexec/"eepget", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin/"i2prouter").write_env_script libexec/"i2prouter", JAVA_HOME: Formula["openjdk"].opt_prefix
    man1.install Dir["#{libexec}/man/*"]
  end

  test do
    assert_match "I2P Service is not running.", shell_output("#{bin}/i2prouter status", 1)
  end
end
