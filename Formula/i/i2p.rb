class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://files.i2p-projekt.de/2.4.0/i2psource_2.4.0.tar.bz2"
  sha256 "30ef8afcad0fffafd94d30ac307f86b5a6b318e2c1f44a023005841a1fcd077c"
  license :cannot_represent

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06d55ee23440f5fce841cb0ece2a041bba3858bdfa62a8944c007d097274d52c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d7b0aec492f18eec2de4b26a235e0906df0dd0075e06e09e6e1c9607dcc7caa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3df8db0f7b82b3a4493d2f8ce4312777644404b0728718a3a90d170abb8f5e8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3ccdf5be45e4295d4d01e1b597e2f4d07a26a67f46546b5300793527f583654"
    sha256 cellar: :any_skip_relocation, ventura:        "33252491ae19ea4661abccb98080213ffa914c04e7ebecc0c598fea3e9028cc3"
    sha256 cellar: :any_skip_relocation, monterey:       "155bde3cc2ec71aa7d9a1716f17766e1054de821cee2acbf761b53f22cbb252e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "731b92c3400edc19ddcb971f82bac8305309dddc6d0481e4f63de48ab0b7986f"
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
