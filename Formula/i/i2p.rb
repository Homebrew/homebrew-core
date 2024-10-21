class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://github.com/i2p/i2p.i2p/releases/download/i2p-2.7.0/i2psource_2.7.0.tar.bz2"
  sha256 "54eebdb1cfdbe6aeb1f60e897c68c6b2921c36ce921350d45d21773256c99874"
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^i2p[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "343b650514b2a3256bcbaeda5a89f4e869d201460cb62daf724d76b173e345b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57db7082ff0f054a016877f123ee9bca2a2f1351e51e98979f23875b5bb767ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a394ee6a32b5bb05261f0ee7a41b61e12a5eeeb34fcc033b650df197bffca15d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a85e7c921aa09030fd3058a358d67b591183fa3616a985255a7f3f7015bbf882"
    sha256 cellar: :any_skip_relocation, ventura:       "4561da032d1b0fb02e77434304a6accd15db7946698e30700e2638e545135ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c3f813ed31c1ca74d9936d39c62ef573c1c96e6802ee8bae3c6292eab8ef7ea"
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
