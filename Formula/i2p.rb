class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://files.i2p-projekt.de/2.0.0/i2psource_2.0.0.tar.bz2"
  sha256 "1d50831e72a8f139cc43d5584c19ca48580d72f1894837689bf644c299df9099"
  license :cannot_represent

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45a65eb4b71fb6ed5df5b186d8f0a5e48ba4056df946e3b03b19ab21914f6c26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76d4d5f640e34d9aa5dae8fd4fce1510306b4211c86c46a7c9dd540e4bf5f3bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74650f2d87ef6817bf8e615f820c73f3fcaacdcb23bba6c462bfb98778993c92"
    sha256 cellar: :any_skip_relocation, monterey:       "9869a854557471178ceaddb9525ea4f0d26471475b267a8aa2e1385a3e2757ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a31977f6a664aeeea23ec2de5058a9df1547894657b73b08ae99d39804a99a6"
    sha256 cellar: :any_skip_relocation, catalina:       "5018081f9e3b21e86cfb41d18c2cf0b9d9a93b71126fa369f35f9af35c8b6d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4480a759a0f64a3ff7d7433696b065e7d599633c3bb3f15c99692bf29a519b7b"
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
