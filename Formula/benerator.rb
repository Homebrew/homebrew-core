class Benerator < Formula
  desc "Tool for realistic test data generation"
  homepage "https://rapiddweller.github.io/homebrew-benerator/"
  url "https://github.com/rapiddweller/rapiddweller-benerator-ce/releases/download/3.1.0/rapiddweller-benerator-ce-3.1.0-jdk-11-dist.tar.gz"
  sha256 "194feb051ae18cfcd407b8e1668ce9c60561394bc454f9fc9747c274166843bc"

  license "Apache-2.0"
  depends_on "openjdk@11"
  def install
    # Remove unnecessary files
    rm_f Dir["bin/*.bat", "bin/pom.xml"]

    # Installs only the 'bin' and 'lib' directories from the tarball
    # Creates the symlinks to 'bin' scripts in /usr/local/bin
    # Creates the symlink to the installation path in /usr/local/opt
    libexec.install Dir["bin", "lib"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Remove non-executable files
    rm_f "#{bin}/benerator_common"
    rm_f "#{bin}/log4j2.xml"
  end

  # opt_prefix is set to the symlink /usr/local/opt/benerator
  def caveats
    <<~EOS
      To use the benerator commands, please set the following environment variables:

      BENERATOR_HOME="#{libexec}"
      JAVA_HOME="$(/usr/libexec/java_home -v 11)"

      For more information, see:
      https://github.com/rapiddweller/rapiddweller-benerator-ce
    EOS
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    ENV["BENERATOR_HOME"] = libexec.to_s
    assert_match "Benerator Community Edition 3.1.0-jdk-11", shell_output("#{libexec}/bin/benerator --version")
  end
end
