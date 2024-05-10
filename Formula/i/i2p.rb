class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://files.i2p-projekt.de/2.5.1/i2psource_2.5.1.tar.bz2"
  sha256 "4bc7e59ee0036389a0f76fc76b2303eeae62bf6eaaf608c9939226febf9ddeae"
  license :cannot_represent

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ceb788369ccd95b8a8b1ce19d8d36aa3af4a3943120e07076c424f600a7f8a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "862ce8b10f9b4c4f2f62d3158889a5fdf2f03a9c31ffb49f23d2d82ec6bd7685"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "145828e41415b892ece9b750636321b10a22914e32b0f2a123cb7ee758253903"
    sha256 cellar: :any_skip_relocation, sonoma:         "55142f3be358e10fc87ebb82c41ab044a70ae3725a556ef4e1e75e4bb9b9048e"
    sha256 cellar: :any_skip_relocation, ventura:        "2db3b5229781ed1c3fd4bb1d5d9967988112841e5f57a27ccaaf4d8b6f180c91"
    sha256 cellar: :any_skip_relocation, monterey:       "f86a885e0e1e9303150eeee65db08aa2379e683aa345b87cc024f5f80a59fbe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb3fcbc3dcebf6558ccc5d10ab47116c22d55fc24e21d2cecb04fa594e3a5614"
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
