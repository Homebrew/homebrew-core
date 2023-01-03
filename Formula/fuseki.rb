class Fuseki < Formula
  desc "SPARQL server"
  homepage "https://jena.apache.org/documentation/fuseki2/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-fuseki-4.7.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-4.7.0.tar.gz"
  sha256 "ac8a76a14cd1f1e9f6e3c73b50571fd5b37a47dd41ce050ea09b6906469afe28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c543feabad850098ae17ad9431fb8c1bf85a621f279f72fdc79fe77c66b8bae"
  end

  depends_on "openjdk"

  def install
    prefix.install "bin"

    %w[fuseki-server fuseki].each do |exe|
      libexec.install exe
      (bin/exe).write_env_script(libexec/exe,
                                 JAVA_HOME:   Formula["openjdk"].opt_prefix,
                                 FUSEKI_BASE: var/"fuseki",
                                 FUSEKI_HOME: libexec,
                                 FUSEKI_LOGS: var/"log/fuseki",
                                 FUSEKI_RUN:  var/"run")
      (libexec/exe).chmod 0755
    end

    # Non-symlinked binaries and application files
    libexec.install "fuseki-server.jar",
                    "webapp"
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
    system "#{bin}/fuseki-server", "--version"
  end
end
