class Fuseki < Formula
  desc "SPARQL server"
  homepage "https://jena.apache.org/documentation/fuseki2/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-fuseki-6.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-6.0.0.tar.gz"
  sha256 "b73d7cdeeed0fba247cece1047e7bc7ef38b7e631de7806e0bd511f32d8fb1ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d07c774dd0289ab4c1006bc45e1e8ed2d190692cfbfc623ac10998492bb4a43"
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
