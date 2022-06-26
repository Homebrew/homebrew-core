class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://files.i2p-projekt.de/1.8.0/i2psource_1.8.0.tar.bz2"
  sha256 "525f2ad3267f130b81296b3dd24102fdcf2adf098d54272da4e1be4abd87df04"
  license :cannot_represent

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca8a42d260af0c83e8dc59c92ff2bba8d3ba6de58ba05c44f9a5de92b0561cff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ff82fc86a81c2e07dc2f1a8bdf6ece7b1f16ea6cae23fce320b621a8770a326"
    sha256 cellar: :any_skip_relocation, monterey:       "64278b24d3bd9abe714aba743d5add3ab1d59d74c7bb70a37131c6def245cc4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f638be6bcb74ea75770a5eda798b751499f607eccce48859b9b838253f4a8124"
    sha256 cellar: :any_skip_relocation, catalina:       "f1e54a09e9f1beefc32886d42b4731c2ad450911f0e3f7efd3411e017c0a9673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1618c80f6619d613190807708f244d73639754a2287058006c68b7e2c6810e30"
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
