class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://github.com/i2p/i2p.i2p/archive/refs/tags/i2p-2.14.0.tar.gz"
  sha256 "603babd72d90f5ee5cd2c68349df29ec16a8d378c2a6cfced40150ca79002cbb"
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^i2p[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0bc193e0be8c803247963f90529cc6b4cc674cde98fe59a98f06ef8f888ebb8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4545b306ef003e9e962c50af731dbc220dee90a0e1abe16d41ba25a82ff55287"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13491c51cd98d6a9a098155fbf5b437895baf33750d5db8e7bf57d79aee930f4"
    sha256 cellar: :any,                 arm64_linux:       "a558c352e3d33c44d55eb3b0b567e083533a8fe508d2f688b8db11b2eefcb5a4"
    sha256 cellar: :any,                 x86_64_linux:      "16e4447091c5735be76f33663b456cccbcf997042adae07864ed4ed10aad0bc3"
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
