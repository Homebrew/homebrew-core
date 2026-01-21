class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://github.com/i2p/i2p.i2p/archive/refs/tags/i2p-2.10.0.tar.gz"
  sha256 "a6e32b50f189f855b1f8131ddc588c0b4841d01aeb94b4040c5a567fe90e8687"
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^i2p[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "851888cddca3a108ace2ace6e99831e156d90dae3fa865170124b1343eb461f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd06ebaabc8c67bede2b8f1af8699ade0a2279af5a7210c76ab4685deb6e36cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a875a3a110b4be3e8a80eb03fd7ed5f486b956eccd7fe5664f2a78f99cffa295"
    sha256 cellar: :any_skip_relocation, sonoma:        "0addddeb241ab03db1521528e6b35f85b69d7f6d268b7f9851b14ca5a2d11049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81dac1db51f037e4bf44be1a1191827bec5054c28b5a94c6a13a636a6cd7bbcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "157a30ec1d313bc9660818297c39754fe462c8f198e25578b6606755d2f07a3c"
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
