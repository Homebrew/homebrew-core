class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://github.com/i2p/i2p.i2p/archive/refs/tags/i2p-2.9.0.tar.gz"
  sha256 "34070d95989abf5c3e922eb31958d696bdbe0bdffde2284aa14e1c763f73d7ea"
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^i2p[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d10735b41070267fa23840521e7bd7448a5f5582ecb40db21a249d66fd3c3640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9cafaf3da69405b8be448701232aff14014d07253c8a115d2da2579a7efc085"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00431dbce28697fc43ef7dd02c3a26d94dd52bc05e0e855cd68a4a0330756ce5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0041a0350fa5a460dcbaad6b798d0cd6217bcbdf642419751d7739212b13d1b3"
    sha256 cellar: :any_skip_relocation, ventura:       "b9de9e24242cccbbfe25de8b082c7cdbeaa36bc501df2c0024091a0acd15bdf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5df693bc55ce843fd3c2ada7120c84763d7bb251aef0c4811e919ba6f6e397be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2c966abff9fcd29e0d682bf45917175326eb013e9d000167bbad023a66cec51"
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
