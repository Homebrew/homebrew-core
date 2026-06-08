class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://github.com/i2p/i2p.i2p/archive/refs/tags/i2p-2.12.0.tar.gz"
  sha256 "5ac52bbfc7e67f29eee2d6080070d2a01f19696f7330156dfaf9a863c3294462"
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^i2p[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9598f0d3922a1cef53ff9bdeb5f2d1140aad309bea712bf12dbf6c87d87d04f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c80b9f6d136c72482018f9274976dc2da530440896401a3b8ebc8530856c9b7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dba50a5ae62c01f278595000375658ae805b40d10804d0b7b630f41528b18b29"
    sha256 cellar: :any_skip_relocation, sonoma:        "e05290889e94eca1ddb0551dc1acbdb3a36185a9c40e7984b726f1305d1eb3de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "527eca7ac163ffc73180dce624845a3043ffaa8fd3412345fc30c368b783bc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "619f04615b01ada40a25bd63bf8f7f6233560f7d5c841d71c277a176cc4c5517"
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
