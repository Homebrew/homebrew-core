class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://github.com/i2p/i2p.i2p/archive/refs/tags/i2p-2.13.0.tar.gz"
  sha256 "1ee645fe313f582f5b605f3e6e8587e952e8fbc9cd7489f0cd93fb68b2b53524"
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^i2p[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9a640a2b009ff563a5098c51471c0681bd65eed2aac2d268078f236fe2c20a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "139bc46c7051ee5c39deade64b89903727028175a40b2e92ccb69836cbef987b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00bfae76bd558ffc637a2087bfddd46169decfa84499b8fb14f87439f0a2b4f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb9c41ff72b84952e996e7346dc50b649f9362f19d82f16f5ea16eff50de2458"
    sha256 cellar: :any,                 arm64_linux:   "e8a493f7fd779bb26428d075295b5888d98d9cb6c4890f85474193f9de841ca6"
    sha256 cellar: :any,                 x86_64_linux:  "2a677f937979daf5f00241aca7aa77d31bf8aaee0769a01e7349a5d1f40bf664"
  end

  depends_on "ant" => :build
  depends_on "gettext" => :build
  depends_on "java-service-wrapper"
  depends_on "openjdk"

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
