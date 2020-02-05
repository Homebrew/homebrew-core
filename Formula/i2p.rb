class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://download.i2p2.de/releases/0.9.44/i2pinstall_0.9.44.jar"
  mirror "https://launchpad.net/i2p/trunk/0.9.44/+download/i2pinstall_0.9.44.jar"
  sha256 "265729c1d676939bc81f96689b72c5f413083f4bbd849393f7629db05523d238"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    (buildpath/"path.conf").write "INSTALL_PATH=#{libexec}"

    system "#{Formula["openjdk"].opt_bin}/java", "-jar", "i2pinstall_#{version}.jar", "-options", "path.conf", "-language", "eng"

    wrapper_name = "i2psvc-macosx-universal-64"
    libexec.install_symlink libexec/wrapper_name => "i2psvc"
    (bin/"eepget").write_env_script libexec/"eepget", :JAVA_HOME => Formula["openjdk"].opt_prefix
    (bin/"i2prouter").write_env_script libexec/"i2prouter", :JAVA_HOME => Formula["openjdk"].opt_prefix
    man1.install Dir["#{libexec}/man/*"]
  end

  test do
    assert_match "I2P Service is not running.", shell_output("#{bin}/i2prouter status", 1)
  end
end
