class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://download.i2p2.de/releases/0.9.26/i2pinstall_0.9.26.jar"
  sha256 "563eb6f2cb9220c380190e90290cd154da3f30b4fa96a212a80e4bbc7a8fd44f"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    (buildpath/"path.conf").write "INSTALL_PATH=#{libexec}"

    system "java", "-jar", "i2pinstall_#{version}.jar", "-options", "path.conf"

    wrapper_name = "i2psvc-macosx-universal-#{MacOS.prefer_64_bit? ? 64 : 32}"
    libexec.install_symlink libexec/wrapper_name => "i2psvc"
    bin.write_exec_script Dir["#{libexec}/{eepget,i2prouter}"]
    man1.install Dir["#{libexec}/man/*"]
  end

  test do
    assert_match "I2P Service is not running.", shell_output("i2prouter status", 1)
  end
end
