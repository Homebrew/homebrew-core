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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56959fa72e0b14e862102993293bf90c0b0a16d5a467fc0aae673da503381ddd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebb408953a0e87c23a9cb838bf833a96c3afdc2313036e2520dbbf2bbbd287dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24830afa2fe1094e634033d61bb38082cd70807498b096a03a9d5fb5b71447c2"
    sha256 cellar: :any_skip_relocation, monterey:       "75ad64bb78affab0ec5b4fe2290be379c5f5eec646fc4131415dfacc1e9b2797"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4605f09824480a90857b4ae2a024454a77d693143914a70df7605ed072e8029"
    sha256 cellar: :any_skip_relocation, catalina:       "0f1ecc018b386c097e962716ce5c9a7142b5f5d10a99c4ddde2de4b91d2235ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b174754721de5e5cbd0d8070764cc2b7e8f59ebe19911288c99398668f0c5b7"
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
