class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://download.i2p2.de/releases/0.9.41/i2pinstall_0.9.41.jar"
  mirror "https://launchpad.net/i2p/trunk/0.9.41/+download/i2pinstall_0.9.41.jar"
  sha256 "3faf1c24c776375694d5f70c53c795ef73e00b21cd4b931ee62b1299b7073fc4"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    (buildpath/"path.conf").write "INSTALL_PATH=#{libexec}"

    system "java", "-jar", "i2pinstall_#{version}.jar", "-options", "path.conf"

    wrapper_name = "i2psvc-macosx-universal-64"
    libexec.install_symlink libexec/wrapper_name => "i2psvc"
    bin.write_exec_script Dir["#{libexec}/{eepget,i2prouter}"]
    man1.install Dir["#{libexec}/man/*"]
  end

  test do
    assert_match "I2P Service is not running.", shell_output("#{bin}/i2prouter status", 1)
  end
end
