class Fuseki < Formula
  desc "SPARQL server"
  homepage "https://jena.apache.org/documentation/fuseki2/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-fuseki-5.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-5.3.0.tar.gz"
  sha256 "0d5647be9bd478930478dde180bcc14f568019a21f8f62ddb1e05c4ba5cf9fb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3519473d17ee889d6be821811502251205c3ed0ba49a3b0675ab456c9fa8aebd"
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
