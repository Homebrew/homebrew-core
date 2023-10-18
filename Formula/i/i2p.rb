class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://files.i2p-projekt.de/2.3.0/i2psource_2.3.0.tar.bz2"
  sha256 "a0a8fb08e9c72eaef22f155b9c9aa0ea90fb331d2bbcf76f82649f0b9efe5f5b"
  license :cannot_represent

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2b7e9a8421e696168c731dbcb11799c75a809eeeb2c80fe356fbf6556c7d734"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f8661aa46b57588c5f7f9c78333bb7710a6e804f48824e8282de7a13b5e82ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6805cc3469c2191601a430fd6adf0c0d314086e95018abd9d08976f81e6ac8f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71a1158f9bd9001f1c849cc2126ca732b1e1d695662f8467e8e91ee76ed5424b"
    sha256 cellar: :any_skip_relocation, sonoma:         "371bf67a53a8119e14115c491335339564fe3d994bab62c10ffc839135c1ff1e"
    sha256 cellar: :any_skip_relocation, ventura:        "c9bf6673c6934eeb41e80947cda5d4f5eb7929dbe8027d2b57f7a961914d3cc4"
    sha256 cellar: :any_skip_relocation, monterey:       "d062cb389788150bda040f9d2e398961fb17d7f397bdb553ec1ca4a30f8fb0c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "63947cc4c72e312d410eb0d4f902a2758eb3d66ea81a787d083422356012e332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e96e9e47d6f21f83b58bb7fb806b5847112ed2b310f4ea173f7be91ef4767d32"
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
