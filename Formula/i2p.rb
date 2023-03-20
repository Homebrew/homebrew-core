class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://files.i2p-projekt.de/2.2.0/i2psource_2.2.0.tar.bz2"
  sha256 "e4ba06a6e2935a17990f057a72b8d79e452a2556a6cefe5012d5dd63466feebf"
  license :cannot_represent

  livecheck do
    url "https://geti2p.net/en/download"
    regex(/href=.*?i2pinstall[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e3aea01209cdbb46160c2de31c93683c5ea1777ce5b3b10203d94589315461a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eb2d8878adda5f5ce913683151f960a988b42b0d30bdc35ba1cc3be38f03abb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dc37b516b7a5a2bab9147a64ee9904a74f1de7ec977082a63c92b57930e2c32"
    sha256 cellar: :any_skip_relocation, ventura:        "630cb1fd98c592d5cc6577c285da6e34d0b975e06ace674c1313c18ee9acf078"
    sha256 cellar: :any_skip_relocation, monterey:       "f4ed1d0fb3b7c100a54a028a24fc09a9d0c4901e91065dfc718ef2319b302680"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d1d262c58080b792902e73a319630668bbdb5790eb385887cd8e0bac7001e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3d0d1ff7984c0dc110233751e2184964111bc74ad66611fe20a9841d0626872"
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
