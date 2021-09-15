class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://launchpad.net/i2p/trunk/0.9.50/+download/i2pinstall_0.9.50.jar"
  sha256 "34902d2a7e678fda9261d489ab315661bd2915b9d0d81165acdee008d9031430"

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91ac9fbb2404651738e12dfdb83cdc52579447b179d0866e4a47edba8cb6c8a4"
    sha256 cellar: :any_skip_relocation, big_sur:       "99cd48d4a4af5c0aca367cd0155473059dc41aaa92ee55ded8b3e91e3d65a6e9"
    sha256 cellar: :any_skip_relocation, catalina:      "1494be1975d2011c1cbdf030c723340bbe91c20a31b44d0ac802791226d8d8bc"
    sha256 cellar: :any_skip_relocation, mojave:        "ece392199586ca726a9f1de563982be8650b55db82c26b6a2dd66b82cab70f6e"
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
