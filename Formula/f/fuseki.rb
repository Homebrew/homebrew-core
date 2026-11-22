class Fuseki < Formula
  desc "SPARQL server"
  homepage "https://jena.apache.org/documentation/fuseki2/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-fuseki-6.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-6.3.0.tar.gz"
  sha256 "0348bd6482c56e989c303a12066d519db124cf8bf916c48b5700058265b63173"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "8d138b72a8d4b4c3a2e6b5ee2940a44ae85e1df459aa5a669f00dfa37e1f4d5e"
    sha256 cellar: :any_skip_relocation, all: "8032de1601b285a520beef7bce56c1e862bf18c49416a2d8de04b7320404cff7"
  end

  depends_on "openjdk"

  def install
    fuseki_env = Language::Java.java_home_env.merge(
      FUSEKI_BASE: var/"fuseki",
      FUSEKI_HOME: libexec,
      FUSEKI_LOGS: var/"log/fuseki",
      FUSEKI_RUN:  var/"run/fuseki",
    )

    bin.install %w[fuseki-server fuseki-backup fuseki-plain]
    bin.env_script_all_files(libexec, fuseki_env)
    chmod 0755, libexec.children
    libexec.install "fuseki-server.jar"

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
