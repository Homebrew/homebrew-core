class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://github.com/i2p/i2p.i2p/archive/refs/tags/i2p-2.14.1.tar.gz"
  sha256 "3db7a3fea2103fd79caf074d7608dfe83c5a026dff746282892805ad51ab7eaf"
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^i2p[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "793e798ff3a1ecb9b8ed8614db769b2e81f5c938c2f065dc161d6d3d202a1ae8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00794a527eacd50af812e3b7eca0843a11e00559e950137cf87c767e56af1560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a2cca3beb80acd9de2ae5f4a3e1f4e2ba13b836d3876890bfee19068059c3d9"
    sha256 cellar: :any,                 arm64_linux:       "83a09bc79380d3d7663575489ae2edbedff410481ebf8c9b0476a48b23eff9f1"
    sha256 cellar: :any,                 x86_64_linux:      "a0d2fdc73661c8a47636b7750f22434eed69c06170160934c9d67a324794db09"
  end

  depends_on "ant" => :build
  depends_on "gettext" => :build
  depends_on "java-service-wrapper"
  depends_on "openjdk"

  deny_network_access!

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    system "ant", "preppkg-#{os}-only"

    libexec.install (buildpath/"pkg-temp").children

    # Replace vendored copy of java-service-wrapper with brewed version.
    rm libexec/"lib/wrapper.jar"
    rm_r(libexec/"lib/wrapper")
    jsw_libexec = formula_opt_libexec("java-service-wrapper")
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
    (bin/"eepget").write_env_script libexec/"eepget", JAVA_HOME: formula_opt_prefix("openjdk")
    (bin/"i2prouter").write_env_script libexec/"i2prouter", JAVA_HOME: formula_opt_prefix("openjdk")
    man1.install Dir["#{libexec}/man/*"]
  end

  test do
    assert_match "I2P Service is not running.", shell_output("#{bin}/i2prouter status", 1)
  end
end
