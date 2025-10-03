class Fuseki < Formula
  desc "SPARQL server"
  homepage "https://jena.apache.org/documentation/fuseki2/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-fuseki-5.5.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-5.5.0.tar.gz"
  sha256 "6499189720e38726af9c0cf1d3b86cf377dcc3a6301b6ac75d0140e3de7e38f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4cf938c4cacd1db4a46386220b3fa56fbba30fecb2d7d8c997985329c6e62128"
  end

  depends_on "openjdk"

  def install
    rm "fuseki-server.bat"

    %w[fuseki-server fuseki-backup fuseki].each do |exe|
      libexec.install exe
      (bin/exe).write_env_script(libexec/exe,
                                 JAVA_HOME:   Formula["openjdk"].opt_prefix,
                                 FUSEKI_BASE: var/"fuseki",
                                 FUSEKI_HOME: libexec,
                                 FUSEKI_LOGS: var/"log/fuseki",
                                 FUSEKI_RUN:  var/"run")
      (libexec/exe).chmod 0755
    end

    libexec.install "fuseki-server.jar"
  end

  def post_install
    # Create a location for dataset and log files,
    # in case we're being used in LaunchAgent mode
    (var/"fuseki").mkpath
    (var/"log/fuseki").mkpath
  end

  service do
    run opt_bin/"fuseki-server"
  end

  test do
    system bin/"fuseki-server", "--version"
  end
end
