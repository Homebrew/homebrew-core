class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://launchpad.net/i2p/trunk/0.9.50/+download/i2pinstall_0.9.50.jar"
  sha256 "34902d2a7e678fda9261d489ab315661bd2915b9d0d81165acdee008d9031430"

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

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
