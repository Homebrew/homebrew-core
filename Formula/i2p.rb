class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://download.i2p2.de/releases/0.9.48/i2pinstall_0.9.48.jar"
  mirror "https://launchpad.net/i2p/trunk/0.9.48/+download/i2pinstall_0.9.48.jar"
  sha256 "5dd5c300d3d2ca4eb7f7b33a2d4c9e54814f02c199c5176db17f214c8ab655d2"

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle :unneeded

  depends_on "openjdk@11"

  def install
    (buildpath/"path.conf").write "INSTALL_PATH=#{libexec}"

    system "#{Formula["openjdk@11"].opt_bin}/java", "-jar", "i2pinstall_#{version}.jar",
                                                 "-options", "path.conf", "-language", "eng"

    wrapper_name = "i2psvc-macosx-universal-64"
    libexec.install_symlink libexec/wrapper_name => "i2psvc"
    (bin/"eepget").write_env_script libexec/"eepget", JAVA_HOME: Formula["openjdk@11"].opt_prefix
    (bin/"i2prouter").write_env_script libexec/"i2prouter", JAVA_HOME: Formula["openjdk@11"].opt_prefix
    man1.install Dir["#{libexec}/man/*"]
  end

  test do
    assert_match "I2P Service is not running.", shell_output("#{bin}/i2prouter status", 1)
  end
end
