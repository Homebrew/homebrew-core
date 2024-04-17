class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://files.i2p-projekt.de/2.5.0/i2psource_2.5.0.tar.bz2"
  sha256 "6bda9aff7daa468cbf6ddf141c670140de4d1db145329645a90c22c1e5c7bc01"
  license :cannot_represent

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92e2a95a93560b33b54be90b72628e43af5e6028b632cb6d27eca3bbea081443"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97fe4c77d3c5f1f296a5b5ba9be6e1d77a2b7b3298cd344378377e4ab4d3357c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b7f1592c6822643183f0fcf11e2cd9c4a1df2d5798a3d359cb188f565245e33"
    sha256 cellar: :any_skip_relocation, sonoma:         "520e003923231e52ddf248131efd899b28d16c4d865202ffa3d542d6f436fb37"
    sha256 cellar: :any_skip_relocation, ventura:        "93fe54dd172423498af75efa9711582af2e3fb90f70163ca33ada738654668c6"
    sha256 cellar: :any_skip_relocation, monterey:       "c13f92f7652b31bc7b288a847da9979d3fe9d5a1da66512e39783de645920159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55935127c4911fc8a9acdfb29ecb65bdd4b3347c78a100c51b3a2659d402c0d1"
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
