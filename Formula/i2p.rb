class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://files.i2p-projekt.de/2.2.1/i2psource_2.2.1.tar.bz2"
  sha256 "f53f34fbe23a8762e3786572751b301befb28288efb6b1042d4fc64c6610784f"
  license :cannot_represent

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1654141c5578004fe8b7898174b5f2deb97ff32788a045d78f759fbdc2b71061"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5112fb1846a1a2b997891b110e29d031eaae5b1f10717ef7e82a14abaf13bc36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b09990c23e5f8fccac37aecd6c2a2bd9efdd1bac56f2b525c1590f1d2fd83fb2"
    sha256 cellar: :any_skip_relocation, ventura:        "274fd7a41e76b8a943c10928dad49a9d3ca71c140e68052def87e0ad8b042ba7"
    sha256 cellar: :any_skip_relocation, monterey:       "9db1e4e1ee223248e7e875b79f41710ea88b36267e303478296564a458c82a6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6263b0dfbb0e0e6fde93fc002585f3f044f90a30584e237a1d48cd4773429cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c93c8ad9c5dc1d5e7a7f9ec59114fb56c0b504938c30787a033c17ebdaa353e"
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
