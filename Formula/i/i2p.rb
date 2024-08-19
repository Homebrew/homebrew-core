class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://github.com/i2p/i2p.i2p/releases/download/i2p-2.6.0/i2psource_2.6.0.tar.bz2"
  sha256 "249b35c1e061e194ee18048b0644cc5e2c5cf785ffce655e3124eb959dc189ff"
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^i2p[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69d1cc70a35cad3a2b3623c740ba4a435fe7223cf088c70acd9757d43a2af1e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b47f1a41de1f7706f247a9e83fe8cdc013ce49044634c1756e609807131c085"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3c5571b87b20745ad112b3ce0de7287dec14202bc99552645b29c96714b8d0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e95ef78d56e6cece0abcbf92405bdb35653647224c1ea31d61818255b66c7afb"
    sha256 cellar: :any_skip_relocation, ventura:        "4fa76ffe8f7ddb4fcabe0f849936333f4e53fa66cab0306195b6a5fd9c8f8837"
    sha256 cellar: :any_skip_relocation, monterey:       "5c00f7c11df525fe71227d7c2d32ab38b89e460e6908254377ac1dc11f2cb18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97de209a215d173a1905b9a70baf8c0767cd94a15775448827767757f9d108ac"
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
