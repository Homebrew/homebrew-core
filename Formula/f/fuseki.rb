class Fuseki < Formula
  desc "SPARQL server"
  homepage "https://jena.apache.org/documentation/fuseki2/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-fuseki-5.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-5.6.0.tar.gz"
  sha256 "5833260ae40a4f0dadc92f11510ad836f00ef63f61ea25aabe16d02d697e818d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5980a1cc4e9216d2f8e352bd28d8e4dcb7610446485073e655f043a100fb1bfd"
  end

  depends_on "openjdk"

  def install
    fuseki_env = Language::Java.java_home_env.merge(
      FUSEKI_BASE: var/"fuseki",
      FUSEKI_HOME: libexec,
      FUSEKI_LOGS: var/"log/fuseki",
      FUSEKI_RUN:  var/"run/fuseki",
    )

    bin.install %w[fuseki-server fuseki-backup fuseki]
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
